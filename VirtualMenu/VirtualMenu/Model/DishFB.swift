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
    var coverPhoto: UIImage? = nil
    var restaurant: String
    
    var storage = Storage.storage()

//    let coverPhoto: CKAsset?
//    let photos: [CKAsset]?
//    let database: CKDatabase
//    var restaurant: CKRecord.Reference? = nil
//    var model: CKRecord.Reference? = nil
//    var reviews: [CKRecord.Reference]? = nil
    
    init(name: String, key: String = "") {
        self.ref = nil
        self.key = key
        self.name = name
        self.description = ""
        self.price = 0
        self.type = ""
        self.coverPhoto = nil
        self.restaurant = ""
    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        guard
            let name = snapshot.data()["Name"] as? String else {
            return nil
        }
        guard let price = snapshot.data()["Price"] as? Double else {
            return nil
        }
        guard let description = snapshot.data()["Description"] as? String else {
            return nil
        }
        guard let type = snapshot.data()["Type"] as? String else {
            return nil
        }
        guard let restau = snapshot.data()["Restaurant"] as? String else {
            return nil
        }
      
        self.ref = nil
        self.key = "nil"
        self.name = name
        self.description = description
        self.price = price
        self.type = type
        self.restaurant = restau
        self.coverPhoto = self.getProfilePhoto()
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
    
    func getProfilePhoto() -> UIImage? {
        var image: UIImage?
        //need current restaurant
        let imagesRef = storage.reference().child("Restaurant/\(self.restaurant)/\(self.name)/cover.png")
        imagesRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
        if let error = error {
            print(error.localizedDescription)
        } else {
          // Data for "virtual-menu-profilephotos/\(name).jpg" is returned
            image = UIImage(data: data!)!
            }
        }
        return image
    }
}
