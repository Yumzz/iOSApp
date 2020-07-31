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
    
    let dispatchGroup = DispatchGroup()

    
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
    
    
//    func fetchOneRestaurantFB(name: String) -> RestaurantFB?{
//            var restaurant: RestaurantFB? = nil
//            db.collection("Restaurant").getDocuments { (rests, error) in
//            if let error = error {
//                   print("Error getting documents: \(error)")
//               } else {
//                   for document in rests!.documents {
//                       print("\(document.documentID) => \(document.data())")
////                    if(document.get("Name") == name){
//                           restaurant = (RestaurantFB(snapshot: document)!)
////                       }
//                   }
//                }
//            }
//        return restaurant
//    }
    
    func fetchRestsDishesFB(name: String){
        self.dispatchGroup.enter()
        print(name)
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
                    dishes.append(DishFB(snapshot: document)!)
                    if(document == snapshot!.documents.last){
                        print("last")
                        self.restDishes = dishes
                        self.dispatchGroup.leave()
                    }
                }
            }
        }
    }
    
    func retrieveDish(dishes: [DishFB]) -> [DishFB]{
        print("dishes: \(dishes)")
        return dishes
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

    
    func fetchDishesFB(restaurant: String){
        var fetchDishes = [DishFB]()
        
        db.collection("Dish").getDocuments { (dishes, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in dishes!.documents {
                    print("\(document.documentID) => \(document.data())")
//                    if(document.get("Restaurant") == restaurant){
                        fetchDishes.append(DishFB(snapshot: document)!)
//                    }
                }
            }
        }
        
//        self.restDishes = fetchDishes
        
    }
    
    func formatPrice(price: Double) -> String {
        return "$" + (price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price))
    }

}
