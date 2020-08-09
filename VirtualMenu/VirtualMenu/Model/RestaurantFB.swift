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
import MapKit

struct RestaurantFB {
    //    let ref: DatabaseReference?
    let id: UUID
    let key: String
    let name: String
    
    let description: String
    let type: String
    let ethnicity: String
    
    var coverPhotoURL: String
    
    var averagePrice: Double
    
    var dishes: [DishFB]? = nil
    
    let coordinate: GeoPoint
    let address: String
    
    //    let coverPhoto: CKAsset?
    //    let photos: [CKAsset]?
    //    var model: CKRecord.Reference? = nil
    //    var reviews: [CKRecord.Reference]? = nil
    
    init(name: String, key: String = "", description: String, averagePrice: Double, type: String, ethnicity: String, dishes: [DishFB], coordinate: GeoPoint, address: String) {
        //        self.ref = nil
        self.id = UUID()
        self.key = key
        self.name = name
        
        self.description = description
        self.type = type
        self.ethnicity = ethnicity
        
        self.coverPhotoURL = "Restaurant/\(self.name.lowercased())/\(self.name.lowercased())_cover.png"
        
        self.averagePrice = averagePrice
        
        self.dishes = dishes
        
        self.coordinate = coordinate
        self.address = address
        
    }
    
    init?(snapshot: QueryDocumentSnapshot){
        
        guard
            let name = snapshot.data()["Name"] as? String else {
                print("no name")
                return nil
        }
        guard
            let ds = snapshot.data()["dishes"] as? [DocumentReference?] else {
                print("dishes messed up")
                return nil
        }
        //dishes is an array of FIRDocumentReference in Firebase and is converted to ds, which is an array of DocumentReferences
        
        guard
            let type = snapshot.data()["Type"] as? String else {
                print("no type")
                return nil
        }
        
        guard
            let description = snapshot.data()["description"] as? String else{
                print("no description")
                return nil
        }
        guard
            let ethnicity = snapshot.data()["Ethnicity"] as? String else {
                print("no ethnicity")
                return nil
        }
        
        guard
            let coordinate = snapshot.data()["location"] as? GeoPoint else {
                print("no coordinate")
                return nil
        }
        
        guard
            let address = snapshot.data()["Address"] as? String else{
                print("no address")
                return nil
        }
        
        self.key = snapshot.documentID
        self.name = name
        self.description = description
        self.averagePrice = 0.0
        self.type = type
        self.ethnicity = ethnicity
        self.coordinate = coordinate
        self.address = address
        self.dishes = []
        self.id = UUID()
        self.coverPhotoURL = "Restaurant/\(self.name.lowercased())/\(self.name.lowercased())_cover.png"
    }
    
    init?(snapshot: QueryDocumentSnapshot, dishes: [DishFB], averagePrice: Double) {
        //        print(snapshot.data())
        guard
            let name = snapshot.data()["Name"] as? String else {
                print("no name")
                return nil
        }
        guard
            let ds = snapshot.data()["dishes"] as? [DocumentReference?] else {
                print("dishes messed up")
                return nil
        }
        //dishes is an array of FIRDocumentReference in Firebase and is converted to ds, which is an array of DocumentReferences
        
        guard
            let type = snapshot.data()["Type"] as? String else {
                print("no type")
                return nil
        }
        
        guard
            let description = snapshot.data()["description"] as? String else{
                print("no description")
                return nil
        }
        guard
            let ethnicity = snapshot.data()["Ethnicity"] as? String else {
                print("no ethnicity")
                return nil
        }
        
        guard
            let coordinate = snapshot.data()["location"] as? GeoPoint else {
                print("no coordinate")
                return nil
        }
        
        guard
            let address = snapshot.data()["Address"] as? String else{
                print("no address")
                return nil
        }
        
        self.key = snapshot.documentID
        self.name = name
        self.description = description
        self.averagePrice = averagePrice
        self.type = type
        self.ethnicity = ethnicity
        self.coordinate = coordinate
        self.address = address
        self.dishes = dishes
        self.id = UUID()
        self.coverPhotoURL = "Restaurant/\(self.name.lowercased())/\(self.name.lowercased())_cover.png"
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
}

