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
    let ethnicity: String
    
    var coverPhotoURL: String
    
    var dishes: [DishFB]? = nil
    var featuredDishRefs: [DocumentReference?]
    
    let coordinate: GeoPoint
    let streetAddress: String
    let cityAddress: String
    var delimiter = ","
    
    let phone: String

//    let coverPhoto: CKAsset?
//    let photos: [CKAsset]?
//    var model: CKRecord.Reference? = nil
//    var reviews: [CKRecord.Reference]? = nil
    var price: String
    var ratingSum: Int64
    var n_Ratings: Int64
    
    
    init(name: String, key: String = "", description: String, averagePrice: Double, ethnicity: String, dishes: [DishFB], featuredDishRefs: [DocumentReference?], coordinate: GeoPoint, address: String, phone: String, price: String, ratingSum: Int64, n_Ratings: Int64) {
//        self.ref = nil
        self.id = UUID()
        self.key = key
        self.name = name
        
        self.description = description
        self.ethnicity = ethnicity
        
        self.coverPhotoURL = "Restaurant/\(self.name.lowercased())/\(self.name.lowercased())_cover.png"
                
        self.dishes = dishes
        self.featuredDishRefs = featuredDishRefs
        self.coordinate = coordinate
        if(address != ""){
            print("wow: \(address.components(separatedBy: delimiter)[2])")
            self.cityAddress = address.components(separatedBy: delimiter)[1] + (address.components(separatedBy: delimiter)[2]).components(separatedBy: " ")[0]
            self.streetAddress = address.components(separatedBy: delimiter)[0]
        }
        else{
            self.cityAddress = address
            self.streetAddress = address
        }
        
        self.phone = phone
        self.ratingSum = ratingSum
        self.n_Ratings = n_Ratings
        self.price = price
        self.price = self.getDollaSigns(price: price)
    }
    
    init?(snapshot: QueryDocumentSnapshot){
       guard
           let name = snapshot.data()["Name"] as? String else {
           print("no rest name")
           return nil
       }
//        guard
//            (snapshot.data()["dishes"] as? [DocumentReference?]) != nil else {
//            print("dishes messed up")
//            return nil
//        }
        
       guard let featuredDishRefs = (snapshot.data()["FeaturedDishes"] as? [DocumentReference?]) else {
           print("featured dishes messed up: \(name)")
           return nil
       }
       //dishes is an array of FIRDocumentReference in Firebase and is converted to ds, which is an array of DocumentReferences
       
//       guard
//           let type = snapshot.data()["Type"] as? String else {
//           print("no type")
//           return nil
//       }
       
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
        guard
            let price = snapshot.data()["price_range"] as? String else {
            print("no coordinate")
            return nil
        }
        guard
            let ratingSum = snapshot.data()["RatingSum"] as? Int64 else {
            print("no RatingSum: \(name)")
            return nil
        }
        guard
            let n_Ratings = snapshot.data()["N_Ratings"] as? Int64 else {
            print("no n_rating")
            return nil
        }
       
       self.key = snapshot.documentID
       self.name = name
       self.description = description
       self.ethnicity = ethnicity
       self.coordinate = coordinate
       self.dishes = []
       self.featuredDishRefs = featuredDishRefs
       self.id = UUID()
       self.coverPhotoURL = "Restaurant/\(self.name.lowercased())/\(self.name.lowercased())_cover.png"
       self.cityAddress = address.components(separatedBy: delimiter)[1] + (address.components(separatedBy: delimiter)[2]).components(separatedBy: " ")[0]
       self.streetAddress = address.components(separatedBy: delimiter)[0]
       self.phone = phone
       self.ratingSum = ratingSum
       self.n_Ratings = n_Ratings
       self.price = price
       self.price = self.getDollaSigns(price: price)
    }
    
    
    init?(snapshot: QueryDocumentSnapshot, dishes: [DishFB]) {
//        print(snapshot.data())

        guard
            let name = snapshot.data()["Name"] as? String else {
                print("no rest name")
                return nil
        }
//        guard
//            let ds = snapshot.data()["dishes"] as? [DocumentReference?] else {
//                print("dishes messed up")
//                return nil
//        }

        //dishes is an array of FIRDocumentReference in Firebase and is converted to ds, which is an array of DocumentReferences
        guard
            let featuredDishRefs = (snapshot.data()["FeaturedDishes"] as? [DocumentReference?]) else {
            print("featured dishes messed up")
            return nil
        }
        
//        guard
//            let type = snapshot.data()["Type"] as? String else {
//                print("no type")
//                return nil
//        }
        
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
        guard
            let price = snapshot.data()["price_range"] as? String else {
            print("no coordinate")
            return nil
        }
        guard
            let ratingSum = snapshot.data()["RatingSum"] as? Int64 else {
            print("no RatingSum")
            return nil
        }
        guard
            let n_Ratings = snapshot.data()["N_Ratings"] as? Int64 else {
            print("no RatingSum")
            return nil
        }
        
        self.id = UUID()
        self.key = snapshot.documentID
        self.name = name
        self.description = description
        self.ethnicity = ethnicity
        self.coordinate = coordinate
        self.dishes = dishes
        self.featuredDishRefs = featuredDishRefs
        self.cityAddress = address.components(separatedBy: delimiter)[1] + (address.components(separatedBy: delimiter)[2]).components(separatedBy: " ")[0]
        self.streetAddress = address.components(separatedBy: delimiter)[0]
        self.coverPhotoURL = "Restaurant/\(self.name.lowercased())/\(self.name.lowercased())_cover.png"
        self.phone = phone
        self.ratingSum = ratingSum
        self.n_Ratings = n_Ratings
        self.price = price
        self.price = self.getDollaSigns(price: price)
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
    
    static func previewRest() -> RestaurantFB {
        return RestaurantFB(name: "", description: "", averagePrice: 0.0, ethnicity: "", dishes: [], featuredDishRefs: [], coordinate: GeoPoint(latitude: 0.0, longitude: 0.0), address: "", phone: "", price: "Low", ratingSum: 5, n_Ratings: 1)
    }
    
    func getDollaSigns(price: String) -> String{
        var p = ""
        if(price == "Low"){
            p = "$"
        }
        else if(price.capitalized == "Medium"){
            p = "$$"
        }
        else if(price == "High"){
            p = "$$$"
        }
        return p
    }
    
}

extension RestaurantFB: Hashable {
    static func == (lhs: RestaurantFB, rhs: RestaurantFB) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
