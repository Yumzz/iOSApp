//
//  RestauarantDishViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on .
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import CloudKit
import Firebase
import MapKit

class RestaurantDishViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var restDishes = [DishFB]()
    
    @Published var rest: RestaurantFB? = nil
    
    @Published var allRests: [RestaurantFB] = [RestaurantFB]()
    
    var images: [String:UIImage] = [String:UIImage]()
    
    var sectionItems: [DishCategory] = [DishCategory]()
    
    let dispatchGroup = DispatchGroup()
    let dispatchGroup1 = DispatchGroup()
    
    
    func fetchRestaurantsFB(){
        db.collection("Restaurant").getDocuments { (snapshot, error) in
        if let error = error {
               print("Error getting documents: \(error)")
           } else {
               for document in snapshot!.documents {
//                   print("\(document.documentID) => \(document.data())")
//                print(document.get("Name") as! String)
                DispatchQueue.main.async {
                    self.fetchRestsDishesFB(name: document.get("Name") as! String)
                    self.dispatchGroup.notify(queue: .main) {
                        let plates = self.restDishes
                        self.allRests.append(RestaurantFB(snapshot: document, dishes: plates, averagePrice: self.getDishAveragePrice(dishes: plates))!)
                    }
                }
               }
            }
        }
    }
    
    
    func fetchSingleRestaurantFB(name: String){
            db.collection("Restaurant").getDocuments { (rests, error) in
            if let error = error {
                   print("Error getting documents: \(error)")
               } else {
                   for document in rests!.documents {
                       print("\(document.documentID) => \(document.data())")
                    if(document.get("Name") as! String == name){
                        self.rest = (RestaurantFB(snapshot: document)!)
                       }
                   }
                }
            }
    }
    
    func fetchRestsDishesFB(name: String){
        self.dispatchGroup.enter()
        let fb = Firestore.firestore()
        
        let ref = fb.collection("Dish")
        
        let query = ref.whereField("Restaurant", isEqualTo: name)
        
        var dishes: [DishFB] = []
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
    //                  print("\(document.documentID) => \(document.data())")
                    let dish = (document.get("Name") as! String)
                    self.getDishPhoto(dishName: dish, restName: name)
                    self.dispatchGroup1.notify(queue: .main) {
                        dishes.append(DishFB(snapshot: document, photo: self.images[dish]!)!)
                        if(document == snapshot!.documents.last){
                            print("last")
                            self.images.removeAll()
                            self.restDishes = dishes
                            self.dispatchGroup.leave()
                        }
                    }
                }
            }
        }
    }
    
    func getDishPhoto(dishName: String, restName: String){
        self.dispatchGroup1.enter()

         var image: UIImage?
         //need current restaurant
         var storage = Storage.storage()
         var dName = dishName
         dName = dName.replacingOccurrences(of: " ", with: "-")
         dName = dName.lowercased()
         
 //        print("name: \(n)")
         
         let imagesRef = storage.reference().child("Restaurant/\(restName.lowercased())/dish/\(dName)/photo/Picture.jpg")
         imagesRef.getData(maxSize: 2 * 2048 * 2048) { data, error in
         if let error = error {
             print(error.localizedDescription)
         } else {
           // Data for "virtual-menu-profilephotos/\(name).jpg" is returned
             if(data == nil){
                 print("Name of dish without photo in FB: \(dName)")
             }
             image = UIImage(data: data!)!
            self.images[dishName] = image!
//            self.images.append(image!)
//            print(self.images)
            self.dispatchGroup1.leave()
            }
         }
     }

    func getDishAveragePrice(dishes: [DishFB]) -> Double{
        var count = 0.0
        var averagePrice = 0.0
        
        for d in dishes {
            count = count + 1
            averagePrice = averagePrice + d.price
            
        }
        
        return averagePrice/count
        
    }
    
    func categorizeDishes(dishes: [DishFB]) {
        var typeToDishes: [String : [DishFB]] = [:]
        for dish in dishes {
            if (typeToDishes[dish.type] == nil) {
                typeToDishes[dish.type] = [dish]
            } else {
                typeToDishes[dish.type]?.append(dish)
            }
        }
        for (category, dishes) in typeToDishes {
            self.sectionItems.append(DishCategory(isExpanded: true, dishes: dishes, name: category))
        }
    }

    
//    func fetchDishesFB(restaurant: String){
//        var fetchDishes = [DishFB]()
//
//        db.collection("Dish").getDocuments { (dishes, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                for document in dishes!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                    if(document.get("Restaurant") == restaurant){
//                    self.getDishPhoto(dishName: (document.get("Name") as! String), restName: restaurant)
//                    fetchDishes.append(DishFB(snapshot: document, photo: self.image!)!)
//                    }
//                }
//            }
//        }
//
//        self.restDishes = fetchDishes
//
//    }
    
    func formatPrice(price: Double) -> String {
        return "$" + (price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price))
    }

}
