//
//  RestaurantFB.swift
//  VirtualMenu
//
//  Created by EageRAssassin on 7/9/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
//import FirebaseFirestore
#if !APPCLIP
import Firebase
#endif
//import FirebaseDatabase
import MapKit


struct RestaurantFB {
    
    #if !APPCLIP
    var ref: DocumentReference? = nil
    var dishes: [DishFB]? = nil
    var featuredDishRefs: [DocumentReference?] = [DocumentReference?]()
    var reviews: [DocumentReference?] = [DocumentReference?]()
    let coordinate: GeoPoint
    #endif

    
    let id: UUID
    let key: String
    let name: String
    
    let description: String
    let ethnicity: String
    
    var coverPhotoURL: String
    

    let streetAddress: String
    let cityAddress: String
    var delimiter = ","
    
    let phone: String

//    let coverPhoto: CKAsset?
//    let photos: [CKAsset]?
//    var model: CKRecord.Reference? = nil
//    var reviews: [CKRecord.Reference]? = nil
    var hour: String = " 9 am - 5 pm"
    var price: String
    var ratingSum: Int64
    var n_Ratings: Int64
    
    
    
    #if !APPCLIP
    init(name: String, key: String = "", description: String, averagePrice: Double, ethnicity: String, dishes: [DishFB], featuredDishRefs: [DocumentReference?], coordinate: GeoPoint, address: String, phone: String, price: String, ratingSum: Int64, n_Ratings: Int64, hour: String) {
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
        self.hour = hour
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
        
//       guard let featuredDishRefs = (snapshot.data()["FeaturedDishes"] as? [DocumentReference?]) else {
//           print("featured dishes messed up: \(name)")
//           return nil
//       }
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
            let n_Ratings = snapshot.data()["N_Ratings"] as? Int64 else {
            print("no n_rating")
            return nil
        }
        guard
            let ratingSum = snapshot.data()["RatingSum"] as? Int64 else {
            print("no RatingSum: \(name)")
            return nil
        }
       
       self.key = snapshot.documentID
       self.name = name
       self.description = description
       self.ethnicity = ethnicity
       self.coordinate = coordinate
       self.dishes = []
       self.id = UUID()
       self.coverPhotoURL = "Restaurant/\(self.name.lowercased())/\(self.name.lowercased())_cover.png"
       self.cityAddress = address.components(separatedBy: delimiter)[1] + (address.components(separatedBy: delimiter)[2]).components(separatedBy: " ")[0]
       self.streetAddress = address.components(separatedBy: delimiter)[0]
       self.phone = phone
       self.ratingSum = ratingSum
       self.n_Ratings = n_Ratings
       self.price = price
       self.price = self.getDollaSigns(price: price)
        if(snapshot.get("hours") != nil){
            if let hours = snapshot.data()["hours"] as? [String:String]{
                let index = Calendar.current.component(.weekday, from: Date())
                self.hour = hours[Calendar.current.weekdaySymbols[index - 1]]!
            }
        }
        if(snapshot.get("FeaturedDishes") != nil){
            if let featuredDishes = snapshot.data()["FeaturedDishes"] as?
                [DocumentReference] {
                self.featuredDishRefs = featuredDishes
            }
        }
        if (snapshot.get("Reviews") != nil) {
            if let reviews = snapshot.data()["Reviews"] as? [DocumentReference] {
                self.reviews = reviews
            }
        }
        self.ref = snapshot.reference
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
//        guard
//            let featuredDishRefs = (snapshot.data()["FeaturedDishes"] as? [DocumentReference?]) else {
//            print("featured dishes messed up")
//            return nil
//        }
        
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
//        guard
//            let hours = snapshot.data()["hours"] as? [String: String] else {
//            print("no hours")
//            return nil
//        }
        
        self.id = UUID()
        self.key = snapshot.documentID
        self.name = name
        self.description = description
        self.ethnicity = ethnicity
        self.coordinate = coordinate
        self.dishes = dishes
        self.cityAddress = address.components(separatedBy: delimiter)[1] + (address.components(separatedBy: delimiter)[2]).components(separatedBy: " ")[0]
        self.streetAddress = address.components(separatedBy: delimiter)[0]
        self.coverPhotoURL = "Restaurant/\(self.name.lowercased())/\(self.name.lowercased())_cover.png"
        self.phone = phone
        self.ratingSum = ratingSum
        self.n_Ratings = n_Ratings
        self.price = price
        self.price = self.getDollaSigns(price: price)
        if(snapshot.get("hours") != nil){
            if let hours = snapshot.data()["hours"] as? [String:String]{
                let index = Calendar.current.component(.weekday, from: Date())
                self.hour = hours[Calendar.current.weekdaySymbols[index - 1]]!
            }
        }
        if(snapshot.get("FeaturedDishes") != nil){
            if let featuredDishes = snapshot.data()["FeaturedDishes"] as? [DocumentReference] {
                self.featuredDishRefs = featuredDishes
            }
        }
        if (snapshot.get("Reviews") != nil) {
            if let reviews = snapshot.data()["Reviews"] as? [DocumentReference] {
                self.reviews = reviews
            }
        }
        self.ref = snapshot.reference
    }
    
    init?(snapshot: DocumentSnapshot){
       guard
           let name = snapshot.data()?["Name"] as? String else {
           print("no rest name")
           return nil
       }
//        guard
//            (snapshot.data()["dishes"] as? [DocumentReference?]) != nil else {
//            print("dishes messed up")
//            return nil
//        }
        
//       guard let featuredDishRefs = (snapshot.data()["FeaturedDishes"] as? [DocumentReference?]) else {
//           print("featured dishes messed up: \(name)")
//           return nil
//       }
       //dishes is an array of FIRDocumentReference in Firebase and is converted to ds, which is an array of DocumentReferences
       
//       guard
//           let type = snapshot.data()["Type"] as? String else {
//           print("no type")
//           return nil
//       }
       
       guard
           let description = snapshot.data()?["description"] as? String else{
               print("no description")
               return nil
       }
       guard
           let ethnicity = snapshot.data()?["Ethnicity"] as? String else {
           print("no ethnicity")
           return nil
       }
        guard
            let address = snapshot.data()?["Address"] as? String else {
            print("no address")
            return nil
        }

       guard
           let coordinate = snapshot.data()?["location"] as? GeoPoint else {
           print("no coordinate")
           return nil
       }
        
        guard
            let phone = snapshot.data()?["Phone"] as? String else {
            print("no coordinate")
            return nil
        }
        guard
            let price = snapshot.data()?["price_range"] as? String else {
            print("no coordinate")
            return nil
        }
        guard
            let n_Ratings = snapshot.data()?["N_Ratings"] as? Int64 else {
            print("no n_rating")
            return nil
        }
        guard
            let ratingSum = snapshot.data()?["RatingSum"] as? Int64 else {
            print("no RatingSum: \(name)")
            return nil
        }
       
       self.key = snapshot.documentID
       self.name = name
       self.description = description
       self.ethnicity = ethnicity
       self.coordinate = coordinate
       self.dishes = []
       self.id = UUID()
       self.coverPhotoURL = "Restaurant/\(self.name.lowercased())/\(self.name.lowercased())_cover.png"
       self.cityAddress = address.components(separatedBy: delimiter)[1] + (address.components(separatedBy: delimiter)[2]).components(separatedBy: " ")[0]
       self.streetAddress = address.components(separatedBy: delimiter)[0]
       self.phone = phone
       self.ratingSum = ratingSum
       self.n_Ratings = n_Ratings
       self.price = price
       self.price = self.getDollaSigns(price: price)
        if(snapshot.get("hours") != nil){
            if let hours = snapshot.data()?["hours"] as? [String:String]{
                let index = Calendar.current.component(.weekday, from: Date())
                self.hour = hours[Calendar.current.weekdaySymbols[index - 1]]!
            }
        }
        if(snapshot.get("FeaturedDishes") != nil){
            if let featuredDishes = snapshot.data()?["FeaturedDishes"] as?
                [DocumentReference] {
                self.featuredDishRefs = featuredDishes
            }
        }
        if (snapshot.get("Reviews") != nil) {
            if let reviews = snapshot.data()?["Reviews"] as? [DocumentReference] {
                self.reviews = reviews
            }
        }
        self.ref = snapshot.reference
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name
        ]
    }
    
    static func previewRest() -> RestaurantFB {
        return RestaurantFB(name: "", description: "", averagePrice: 0.0, ethnicity: "", dishes: [], featuredDishRefs: [], coordinate: GeoPoint(latitude: 0.0, longitude: 0.0), address: "", phone: "", price: "Low", ratingSum: 5, n_Ratings: 1, hour: "")
    }
    #else

    init?(json: [String:Any]){
        guard let description = json["description"] as? String,
              let name = json["Name"] as? String,
              let price_range = json["price_range"] as? String,
              let ethnicity = json["Ethnicity"] as? String,
              let locationDict = json["location"] as? [String:Double],
//              let latitude = locationDict["_latitude"] as? Double,
//              let longitude = locationDict["_longitude"] as? Double,
              let hours = json["hours"] as? [String:String],
              let phone = json["Phone"] as? String,
              let address = json["Address"] as? String,
              let key = json["id"] as? String,
              let num_ratings = json["N_Ratings"] as? Int64,
              let rating_sum = json["RatingSum"] as? Int64
        else {
            print("initialization failed")
            return nil
        }
        let index = Calendar.current.component(.weekday, from: Date())
        self.hour = hours[Calendar.current.weekdaySymbols[index - 1]]!
        
        self.id = UUID()
        self.key = key
        self.description = description
        self.name = name
        self.price = price_range
        self.ethnicity = ethnicity
//        self.hours
        self.phone = phone

        self.cityAddress = (address as AnyObject).components(separatedBy: delimiter)[1] + ((address as AnyObject).components(separatedBy: delimiter)[2]).components(separatedBy: " ")[0]
        self.streetAddress = (address as AnyObject).components(separatedBy: delimiter)[0]
        self.coverPhotoURL = "Restaurant/\(self.name.lowercased())/\(self.name.lowercased())_cover.png"
        self.ratingSum = rating_sum
        self.n_Ratings = num_ratings
//              let location = CLLocation(latitude: (((locationDict["_latitude"])!)), longitude: ((locationDict["_longitude"])!)),
              
//              let location = CLLocation(latitude: (((json["location"]["_latitude"] as? Double)!)), longitude: ((json["location"]["_longitude"] as? Double)!))
        
    }
    
    #endif
    
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
