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
    var storage = Storage.storage().reference()
    let key: String
    #endif
    let name: String
    var description: String
    let price: Double
    let type: String
    var coverPhotoURL: String = ""
    var restaurant: String
    var id: UUID
    var options: [String:Float] = [String:Float]()
    var exclusive: Bool = true
    var dishCatDescription: String = ""
    var photoExists = false
    var tp_tags : [String] = [""]
    var tp_nums : [Int] = [0]
//  if there is an or in a sentence - you can choose one of them
    // add - choices
    // substitute - a for b
    var choices: [String:[String:[String]]] = ["":["":[""]]]
    
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
//        if(storage.child("Restaurant/\(self.coverPhotoURL)") != nil){
//            print("no image exists")
//            self.photoExists = true
//        }
        self.id = UUID()
        let descriptcomponents = description.components(separatedBy: ". ")
        for dcomponent in descriptcomponents {
            if (dcomponent.contains("or")){
                print(dcomponent)
            }
            
        }
        var exist = false
        var url = ""
        self.coverPhotoURL = url
        self.photoExists = exist
        
    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        guard
            let name = snapshot.data()["Name"] as? String else {
                print("no dish name:\(snapshot.data())")
                return nil
        }
        guard var price = snapshot.data()["Price"] as? String else {
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
//        if(storage.child("Restaurant/\(self.coverPhotoURL)") != nil){
//            print("no image exists")
//            self.photoExists = true
//        }
        if(snapshot.get("taste_profile") != nil){
            let taste = (snapshot.data()["taste_profile"] as? [Int])!
            let taste_tags = (snapshot.data()["tp_tags"] as? [String])!
            self.tp_tags = taste_tags
            self.tp_nums = taste
        }
        self.id = UUID()
        self.ref = nil
        self.key = snapshot.documentID
        self.name = name
        self.description = description
        let descriptcomponents = description.components(separatedBy: ". ")
        for dcomponent in descriptcomponents {
            if (dcomponent.contains("or")){
                print(dcomponent)
            }
            
        }
        
        self.price = (price as NSString).doubleValue
//        let y = Float(price)
        
//        let formatter = NumberFormatter()
//        formatter.minimumFractionDigits = 2
//        self.price = formatter.stringFromNumber(y)
//        self.price = Double.init(price)!
        
//        if(name.contains("Bello")){
//            print("coach price: \(self.price)")
//        }
        
        self.type = type
        self.restaurant = restau
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
            if(self.photoExists){
                
            }
        }
        else{
            print("name of no image exists: \(name)")
            self.coverPhotoURL = ""
            self.photoExists = false
        }
        if(snapshot.get("choices") != nil){
            print(snapshot.data()["choices"])
            self.choices = ((snapshot.data()["choices"] as? [String:[String:[String]]])!)
        }
        if(snapshot.get("photoExists") != nil){
            print("photoexists variable: \(name)")
            self.photoExists = (snapshot.data()["photoExists"] as? Bool)!
            if self.photoExists {
                self.coverPhotoURL = "Restaurant/\(self.restaurant.lowercased())/dish/\(self.name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg"
                print("image exists: \(name)")
                self.photoExists = true
            }
            else{
                self.coverPhotoURL = ""
                self.photoExists = false
            }
            
        }
        else{
            var exist = false
            var url = ""

            self.coverPhotoURL = url
            self.photoExists = exist
        }
    }
    
    init?(snapshot: DocumentSnapshot) {
        guard
            let name = snapshot.data()?["Name"] as? String else {
                print("no dish name: \(snapshot.data())")
                return nil
        }
        guard var price = snapshot.data()?["Price"] as? String else {
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
        if(snapshot.get("taste_profile") != nil){
            guard let taste = snapshot.data()?["taste_profile"] as? [Int] else {
                print("no taste_profile")
                return nil
            }
            guard let taste_tags = snapshot.data()?["tp_tags"] as? [String] else {
                print("no tp_tags")
                return nil
            }
//            let taste = (snapshot.data()!["taste_profile"] as? [String])!
//            let taste_tags = (snapshot.data()!["tp_tags"] as? [String])!
            self.tp_tags = taste_tags
            self.tp_nums = taste
        }
        

        self.id = UUID()
        self.ref = nil
        self.key = snapshot.documentID
        self.name = name
        self.description = description
        let descriptcomponents = description.components(separatedBy: ". ")
        for dcomponent in descriptcomponents {
            if (dcomponent.contains("or")){
                print(dcomponent)
            }
        }
        self.price = (price as NSString).doubleValue
        
        
        self.type = type
        self.restaurant = restau
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
            self.coverPhotoURL = "Restaurant/\(self.restaurant.lowercased())/dish/\(self.name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg"
            print("image exists: \(name)")
            self.photoExists = true
            print("photoexists variable: \(name)")
        }
        else{
            var exist = false
            var url = ""
            self.coverPhotoURL = url
            self.photoExists = exist
        }

        if(snapshot.get("choices") != nil){
            self.choices = (snapshot.data()!["choices"] as? [String:[String:[String]]])!
            print("hello: \(self.choices)")
        }
//        else{
//            print("no image exists")
//            self.photoExists = false
//        }
    }
    
    init?(json: [String:Any], dis: DispatchGroup){
        print("here in dishfb")
        guard let description = json["Description"] as? String,
              let name = json["Name"] as? String,
              let type = json["Type"] as? String,
              let restID = json["RestaurantID"] as? String,
              var price = json["Price"] as? String,
              let rest = json["Restaurant"] as? String
        else {
            print("initialization failed")
            return nil
        }
        
        self.id = UUID()
        self.name = name
        self.description = description
        let descriptcomponents = description.components(separatedBy: ". ")
        var sentencenum = 0
        for dcomponent in descriptcomponents {
            sentencenum = sentencenum + 1
            if (dcomponent.contains(" or ")){
                print(dcomponent)
            }
        }
        
        let p = NSString(string: price)
        self.price = p.doubleValue
        self.type = type
        self.restaurant = rest
        self.id = UUID()
        self.ref = DatabaseReference()
        self.key = ""
//        print("Restaurant/\(self.restaurant.lowercased())/dish/\(self.name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg")
        let y = storage.child("Restaurant/\(self.restaurant.lowercased())/dish/\(self.name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg".replacingOccurrences(of: "\\", with: ""))
        var exist = false
        var url = ""
//        y.getMetadata {
//            metadata, error in
//              if let error = error {
//                // Uh-oh, an error occurred!
//                print("no photoexists: \(name)")
//                exist = false
//              } else {
//                // Metadata now contains the metadata for 'images/forest.jpg'
//                print("photoexists variable2: \(name)")
//                exist = true
//                url = "Restaurant/\(rest.lowercased())/dish/\(name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg"
//              }
//            }
        self.coverPhotoURL = url
        self.photoExists = exist

        print("name of dish: \(self.name)")
        dis.leave()
        
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
        let descriptcomponents = description.components(separatedBy: ". ")
        var sentencenum = 0
        for dcomponent in descriptcomponents {
            sentencenum = sentencenum + 1
            if (dcomponent.contains(" or ")){
                print(dcomponent)
            }
        }
        
        let p = NSString(string: price)
        self.price = p.doubleValue
        self.type = type
        self.coverPhotoURL = "Restaurant/\(rest.lowercased())/dish/\(name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg"
        self.restaurant = rest
        self.id = UUID()
//        self.tp_tags = tp_tags
//        self.tp_nums = tp_nums
//        self.key = key


//              let location = CLLocation(latitude: (((locationDict["_latitude"])!)), longitude: ((locationDict["_longitude"])!)),
              
//              let location = CLLocation(latitude: (((json["location"]["_latitude"] as? Double)!)), longitude: ((json["location"]["_longitude"] as? Double)!))
        
    }
    
    init?(json: [String:Any], dis: DispatchGroup){
        guard let description = json["Description"] as? String,
              let name = json["Name"] as? String,
              let type = json["Type"] as? String,
              let restID = json["RestaurantID"] as? String,
              var price = json["Price"] as? String,
              let rest = json["Restaurant"] as? String,
              let tp_nums = json["taste_profile"] as? [Int],
            let tp_tags = json["tp_tags"] as? [String]
            else {
            print("initialization failed")
            return nil
        }
        
        guard let choices = json["choices"] as? [String:[String:[String]]] else {
            print("no choices")
            let choices = ["":[""]]
            return nil
        }
        
        if(choices != ["":["":[""]]]){
            print(choices)
            self.choices = choices
        }
        
        self.id = UUID()
        
//        self.key = key
        self.name = name
        self.description = description
        let descriptcomponents = description.components(separatedBy: ". ")
        var sentencenum = 0
        for dcomponent in descriptcomponents {
            sentencenum = sentencenum + 1
            if (dcomponent.contains(" or ")){
                print(dcomponent)
            }
        }
        let pa = price.components(separatedBy: ".")[1]
        if pa.count < 1{
            price = price + "00"
        }
        else{
            if pa.count < 2{
                price = price + "0"

            }
        }
        let p = NSString(string: price)
        self.price = p.doubleValue
        self.type = type
        self.coverPhotoURL = "Restaurant/\(rest.lowercased())/dish/\(name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg".replacingOccurrences(of: "//", with: "")
        print("Restaurant/\(self.coverPhotoURL)")
        self.restaurant = rest
//        self.tp_nums = tp_nums
//        self.tp_tags = tp_tags
        self.id = UUID()
        dis.leave()

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
    
    static func priceFix(price: String) -> String {
        if(price.components(separatedBy: ".")[1].count < 2){
            if(price.components(separatedBy: ".")[1].count < 1){
                return price + "00"
            }
            else{
                return price + "0"
            }
        }
        else{
            return price
        }
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



//            y.getMetadata {
//                metadata, error in
//                  if let error = error {
//                    // Uh-oh, an error occurred!
//                    print("no photoexists: \(name)")
//                    exist = false
//                  } else {
//                    // Metadata now contains the metadata for 'images/forest.jpg'
//                    print("photoexists variable2: \(name)")
//                    exist = true
//                    url = "Restaurant/\(restau.lowercased())/dish/\(name.lowercased().replacingOccurrences(of: " ", with: "-"))/photo/Picture.jpg"
//                  }
//                }
//              let location = CLLocation(latitude: (((locationDict["_latitude"])!)), longitude: ((locationDict["_longitude"])!)),
              
//              let location = CLLocation(latitude: (((json["location"]["_latitude"] as? Double)!)), longitude: ((json["location"]["_longitude"] as? Double)!))
