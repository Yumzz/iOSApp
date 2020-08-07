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
    let key: String
    let name: String
    let description: String
    var averagePrice: Double
    let type: String
    var dishes: [DishFB]? = nil
    let ethnicity: String
    let coordinate: GeoPoint
    let id: UUID
    let address: String
    let phone: String
//    let coverPhoto: CKAsset?
//    let photos: [CKAsset]?
//    var model: CKRecord.Reference? = nil
//    var reviews: [CKRecord.Reference]? = nil
    var price: Price
    
    enum Price {
        case low
        case medium
        case high
    }
    
    init(name: String, key: String = "", description: String, averagePrice: Double, type: String, ethnicity: String, dishes: [DishFB], coordinate: GeoPoint, address: String, phone: String) {
//        self.ref = nil
        self.key = key
        self.name = name
        self.description = description
        self.averagePrice = averagePrice
        self.type = type
        self.ethnicity = ethnicity
        self.dishes = dishes
        self.coordinate = coordinate
        self.id = UUID()
        self.address = address
        self.phone = phone
        self.price = Price.low
        self.price = self.getPriceRange(averagePrice: averagePrice)
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
            let address = snapshot.data()["Address"] as? String else {
            print("no address")
            return nil
        }

       guard
           let coordinate = snapshot.data()["location"] as? GeoPoint else {
           print("no coordinate")
           return nil
       }
        
        guard
            let phone = snapshot.data()["Phone"] as? String else {
            print("no coordinate")
            return nil
        }
       
       self.key = snapshot.documentID
       self.name = name
       self.description = description
       self.averagePrice = 0.0
       self.type = type
       self.ethnicity = ethnicity
       self.coordinate = coordinate
       self.dishes = []
       self.id = UUID()
       self.address = address
       self.phone = phone
       self.price = Price.low
       self.price = self.getPriceRange(averagePrice: averagePrice)
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
            let address = snapshot.data()["Address"] as? String else {
            print("no address")
            return nil
        }

        guard
            let coordinate = snapshot.data()["location"] as? GeoPoint else {
            print("no coordinate")
            return nil
        }
        guard
            let phone = snapshot.data()["Phone"] as? String else {
            print("no coordinate")
            return nil
        }
        
        self.key = snapshot.documentID
        self.name = name
        self.description = description
        self.averagePrice = averagePrice
        self.type = type
        self.ethnicity = ethnicity
        self.coordinate = coordinate
        self.dishes = dishes
        self.id = UUID()
        self.address = address
        self.phone = phone
        self.price = Price.low
        self.price = self.getPriceRange(averagePrice: averagePrice)
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
    
    func getPriceRange(averagePrice: Double) -> Price{
        var price = Price.low
        if(averagePrice <= 20){
            price = Price.low
        }
        else{
            if(averagePrice <= 40){
                price = Price.medium
            }
            else{
                price = Price.high
            }
        }
        
        return price
        
    }
    
    static func previewRest() -> RestaurantFB {
        return RestaurantFB(name: "", description: "", averagePrice: 0.0, type: "", ethnicity: "", dishes: [], coordinate: GeoPoint(latitude: 0.0, longitude: 0.0), address: "", phone: "")
    }
    
}

