//
//  RestaurantFB.swift
//  VirtualMenu
//
//  Created by EageRAssassin on 7/9/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseDatabase

struct RestaurantFB {
    let ref: DatabaseReference?
    let key: String
    let name: String
    let description: String
    let price: Double
    let type: String
    var dishes: [DishFB]? = nil
    let ethnicity: String
    let coordinate: GeoPoint
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
        self.ethnicity = ""
        self.dishes = []
        self.coordinate = GeoPoint(latitude: 1.1, longitude: 1.1)
    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        guard
            let name = snapshot.data()["name"] as? String else {
            return nil
        }
        guard
            let dishes = snapshot.data()["dishes"] as? [DishFB] else {
            return nil
        }
        
        guard
            let type = snapshot.data()["dishes"] as? String else {
            return nil
        }
        
        guard
            let ethnicity = snapshot.data()["Ethnicity"] as? String else {
            return nil
        }
        
        guard
            let coordinate = snapshot.data()["location"] as? GeoPoint else {
            return nil
        }
      
        self.ref = nil
        self.key = "nil"
        self.name = name
        self.description = ""
        self.price = 0
        self.type = type
        self.dishes = dishes
        self.ethnicity = ethnicity
        self.coordinate = coordinate
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
}
