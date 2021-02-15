//
//  Cache.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 2/3/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore


final class Cache<Key:Hashable, Value>{
    private let wrapped = NSCache<WrappedKey, Entry>()
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    private let keyTracker = KeyTracker()
    
    init(dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval = 12 * 60 * 60, maximumEntryCount: Int = 50) {
            self.dateProvider = dateProvider
            self.entryLifetime = entryLifetime
            wrapped.countLimit = maximumEntryCount
            wrapped.delegate = keyTracker
        }
    
    func insert(_ value: Value, forKey key: Key) {
            let date = dateProvider().addingTimeInterval(entryLifetime)
            let entry = Entry(value: value, expirationDate: date)
            wrapped.setObject(entry, forKey: WrappedKey(key))
            keyTracker.keys.insert(key)
        }

    func value(forKey key: Key) -> Value? {
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
                return nil
            }

            guard dateProvider() < entry.expirationDate else {
                // Discard values that have expired
                removeValue(forKey: key)
                return nil
            }

            return entry.value
        }
        

        func removeValue(forKey key: Key) {
            wrapped.removeObject(forKey: WrappedKey(key))
        }
}

private extension Cache {
    final class WrappedKey: NSOBject {
        let key: Key
        
        init(_ key:Key) {self.key = key}
        
        override var hash: Int { return key.hashValue }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }
    
    final class KeyTracker: NSObject, NSCacheDelegate {
        var keys = Set<Key>()
        
        func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject object: Any) {
            guard let entry = object as? Entry else {
                return
            }
            
            keys.remove(entry.key)
        }
    }
    func entry(forKey key: Key) -> Entry? {
            guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
                return nil
            }

            guard dateProvider() < entry.expirationDate else {
                removeValue(forKey: key)
                return nil
            }

            return entry
        }

        func insert(_ entry: Entry) {
            wrapped.setObject(entry, forKey: WrappedKey(entry.key))
            keyTracker.keys.insert(entry.key)
        }
}

private extension Cache {
    final class Entry {
        let value: Value
        let expirationDate: Date
        let key: Key
        
        init(key: Key, value: Value, expirationDate: Date){
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}

extension Cache {
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }

            insert(value, forKey: key)
        }
    }
//    static func getCache() -> Cache {
//        return Cache
//    }
}

final class RestLoader: ObservableObject {
    typealias Handler = (Result<RestaurantFB, Error>) -> Void
    
    private let cache = Cache<String, RestaurantFB>()
    
    func loadRest(withID id: String, then handler: @escaping Handler){
        if let cached = cache[id] {
            return handler(.success(cached))
        }
        else{
        
            let db = Firestore.firestore()
            let ref = db.collection("Restaurant").document(id)
            
            ref.getDocument { (doc, er) in
                if let doc = doc, doc.exists {
                    let dataDescription = doc.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
            }
        
        }
        }
    }
}

final class DishLoader: ObservableObject {
    typealias Handler = (Result<DishFB, Error>) -> Void
    
    private let cache = Cache<String, DishFB>()
    
    func loadDish(withID id: String, then handler: @escaping Handler){
        if let cached = cache[id] {
            return handler(.success(cached))
        }
        else{
            
            let db = Firestore.firestore()
            let ref = db.collection("Dish").document(id)
            
            ref.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
            }
        
        }
        
    }
}

extension Cache.Entry: Codable where Key: Codable, Value: Codable {
    convenience init(from decoder: Decoder) throws {
            self.init()

            let container = try decoder.singleValueContainer()
            let entries = try container.decode([Entry].self)
            entries.forEach(insert)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(keyTracker.keys.compactMap(entry))
        }
}

extension Cache where Key: Codable, Value: Codable {
    func saveToDisk(
        withName name: String,
        using fileManager: FileManager = .default
    ) throws {
        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )

        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
        let data = try JSONEncoder().encode(self)
        try data.write(to: fileURL)
    }
}
