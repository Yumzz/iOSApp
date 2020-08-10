//
//  DishFB.swift
//  VirtualMenu
//
//  Created by EageRAssassin on 7/1/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseDatabase

struct DishFB {
    let ref: DatabaseReference?
    let key: String
    let name: String
    let description: String
    let price: Double
    let type: String
    var coverPhoto: UIImage?
    var restaurant: String
    var id: UUID
    
    var storage = Storage.storage()
    
    init(name: String, key: String = "", description: String, price: Double, type: String, restaurant: String) {
        self.ref = nil
        self.key = key
        self.name = name
        self.description = description
        self.price = price
        self.type = type
        self.coverPhoto = nil
        self.restaurant = restaurant
        self.id = UUID()
    }
    
    init?(snapshot: QueryDocumentSnapshot, photo: UIImage) {
        guard
            let name = snapshot.data()["Name"] as? String else {
            print("no name")
            return nil
        }
        guard let price = snapshot.data()["Price"] as? String else {
            print("no price")
            return nil
        }
        guard let description = snapshot.data()["Description"] as? String else {
            print("no description")
            return nil
        }
        guard let type = snapshot.data()["Type"] as? String else {
            print("no type")
            return nil
        }
        guard let restau = snapshot.data()["Restaurant"] as? String else {
            print("no rest")
            return nil
        }
        self.id = UUID()
        self.ref = nil
        self.key = snapshot.documentID
        self.name = name
        self.description = description
        
        self.price = (price as NSString).doubleValue
        
        self.type = type
        self.restaurant = restau
        self.coverPhoto = photo
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
}

extension DishFB: Hashable {
    static func == (lhs: DishFB, rhs: DishFB) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func previewDish() -> DishFB {
        return DishFB(name: "", description: "", price: 0.0, type: "", restaurant: "")
    }
    
    
    static func formatPrice(price: Double) -> String {
        var x =  "$" + (price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price))
        if(x.numOfNums() < 3){
            x = x + "0"
        }
        return x
    }
    
}
