//
//  DishFB.swift
//  VirtualMenu
//
//  Created by EageRAssassin on 7/1/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
#if !APPCLIP
//import FirebaseFirestore
import Firebase
//import FirebaseDatabase
#endif

struct DishFB {
    #if !APPCLIP
    let ref: DatabaseReference?
    var storage = Storage.storage()
    let key: String
    #endif
    let name: String
    let description: String
    let price: Double
    let type: String
    var coverPhotoURL: String
    var restaurant: String
    var id: UUID
    var options: [String:Float] = [String:Float]()
    var exclusive: Bool = true
    var dishCatDescription: String = ""
    var photoExists = false
    
    #if !APPCLIP
    init(name: String, key: String = "", description: String, price: Double, type: String, restaurant: String) {
        self.ref = nil
        self.key = key
        self.name = name
        self.description = description
        self.price = price
        self.type = type
        self.restaurant = restaurant
        self.coverPhotoURL = "\(self.restaurant.lowercased())/dish/\(self.name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg"
        self.id = UUID()
    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        guard
            let name = snapshot.data()["Name"] as? String else {
                print("no dish name:\(snapshot.data())")
                return nil
        }
        guard let price = snapshot.data()["Price"] as? String else {
            print("no price: \(name)")
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
            print("no dishes' rest")
            return nil
        }

        self.id = UUID()
        self.ref = nil
        self.key = snapshot.documentID
        self.name = name
        self.description = description
        
        self.price = (price as NSString).doubleValue
//        self.options = self. options
        self.type = type
        self.restaurant = restau
        self.coverPhotoURL = "Restaurant/\(self.restaurant.lowercased())/dish/\(self.name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg"
        if(snapshot.get("options") != nil){
            if let options = snapshot.data()["options"] as? [String:[String]]{
                self.options = self.extractOptions(opts: options)
            }
            if let exclusive = snapshot.data()["exclusive_opt"] as? Bool{
                self.exclusive = exclusive
            }
        }
        if(snapshot.get("dishCatDescript") != nil){
            self.dishCatDescription = (snapshot.data()["dishCatDescript"] as? String)!
        }
        if(snapshot.get("photoExists") != nil){
            self.photoExists = (snapshot.data()["photoExists"] as? Bool)!
        }
        else{
            self.coverPhotoURL = ""
        }
    }
    
    init?(snapshot: DocumentSnapshot) {
        guard
            let name = snapshot.data()?["Name"] as? String else {
                print("no dish name: \(snapshot.data())")
                return nil
        }
        guard let price = snapshot.data()?["Price"] as? String else {
            print("no price")
            return nil
        }
        guard let description = snapshot.data()?["Description"] as? String else {
            print("no description: \(snapshot.data()?["Description"])")
            return nil
        }
        guard let type = snapshot.data()?["Type"] as? String else {
            print("no type")
            return nil
        }
        guard let restau = snapshot.data()?["Restaurant"] as? String else {
            print("no dishes' rest")
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
        self.coverPhotoURL = "Restaurant/\(self.restaurant.lowercased())/dish/\(self.name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg"
        if(snapshot.get("options") != nil){
            if let options = snapshot.data()!["options"] as? [String:[String]]{
                self.options = self.extractOptions(opts: options)
            }
            if let exclusive = snapshot.data()!["exclusive_opt"] as? Bool{
                self.exclusive = exclusive
            }
        }
        if(snapshot.get("dishCatDescript") != nil){
            self.dishCatDescription = (snapshot.data()!["dishCatDescript"] as? String)!
        }
        if(snapshot.get("photoExists") != nil){
            self.photoExists = (snapshot.data()!["photoExists"] as? Bool)!
        }
        else{
            self.coverPhotoURL = ""
        }
    }
    #else
    init?(json: [String:Any]){
        guard let description = json["Description"] as? String,
              let name = json["Name"] as? String,
              let type = json["Type"] as? String,
              let restID = json["RestaurantID"] as? String,
              let price = json["Price"] as? String,
              let rest = json["Restaurant"] as? String
        else {
            print("initialization failed")
            return nil
        }
        
        self.id = UUID()
        
//        self.key = key
        self.name = name
        self.description = description
        let p = NSString(string: price)
        self.price = p.doubleValue
        self.type = type
        self.coverPhotoURL = "Restaurant/\(rest.lowercased())/dish/\(name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg"
        self.restaurant = rest
        self.id = UUID()
//        self.key = key


//              let location = CLLocation(latitude: (((locationDict["_latitude"])!)), longitude: ((locationDict["_longitude"])!)),
              
//              let location = CLLocation(latitude: (((json["location"]["_latitude"] as? Double)!)), longitude: ((json["location"]["_longitude"] as? Double)!))
        
    }
    #endif
    
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
        #if !APPCLIP
        return DishFB(name: "", description: "", price: 0.0, type: "", restaurant: "")
        #else
        return DishFB(json: ["Description":"", "Name" : "", "Type" : "", "RestaurantID" : "", "Price":"", "Restaurant":""])!
        #endif
    }
    
    
    static func formatPrice(price: Double) -> String {
        var x =  "$" + (price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price))
        print(x)
        if let range = x.range(of: ".") {
            let afterdeci = x[range.upperBound...].trimmingCharacters(in: .whitespaces)
            print(afterdeci) // prints "123.456.7891"
            if(afterdeci.numOfNums() < 2){
                print(x.numOfNums())
                print("less")
                x = x + "0"
                print(x)
            }
//            if(afterdeci.numOfNums() > 2){
//
//            }
        }
        print("x: \(x)")
        return x
    }
    
    func extractOptions(opts: [String:[String]]) -> [String:Float]{
        let names = opts["Name"]
        let prices = opts["Price"]
        var o = [String:Float]()
        var i = 0
        while i < names!.count{
            o[names![i]] = Float(prices![i])
            i = i + 1
        }
        return o
    }
    
}
