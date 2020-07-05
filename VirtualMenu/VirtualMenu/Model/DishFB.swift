//
//  DishFB.swift
//  VirtualMenu
//
//  Created by EageRAssassin on 7/1/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import Firebase

struct DishFB {
    let ref: DatabaseReference?
    let key: String
    let name: String
    let description: String
    let price: Double
    let type: String
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
    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        guard
            let name = snapshot.data()["name"] as? String else {
            return nil
        }
      
        self.ref = nil
        self.key = "nil"
        self.name = name
        self.description = ""
        self.price = 0
        self.type = ""
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
}
