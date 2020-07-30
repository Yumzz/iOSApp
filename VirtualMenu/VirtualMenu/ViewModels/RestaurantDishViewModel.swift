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

class RestaurantDishViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var dish = [DishFB]()
    
    @Published var rest: RestaurantFB? = nil
    
    @Published var allRests: [RestaurantFB] = [RestaurantFB]()
    
    func fetchRestaurantsFB(){
        var restaurants: [RestaurantFB] = [RestaurantFB]()
        db.collection("Restaurant").getDocuments { (rests, error) in
        if let error = error {
               print("Error getting documents: \(error)")
           } else {
               for document in rests!.documents {
                   print("\(document.documentID) => \(document.data())")
                restaurants.append((RestaurantFB(snapshot: document)!))
               }
            }
        }
        self.allRests = restaurants
    }
    
    func fetchOneRestaurantFB(name: String){
            var restaurant: RestaurantFB? = nil
            db.collection("Restaurant").getDocuments { (rests, error) in
            if let error = error {
                   print("Error getting documents: \(error)")
               } else {
                   for document in rests!.documents {
                       print("\(document.documentID) => \(document.data())")
//                    if(document.get("Name") == name){
                           restaurant = (RestaurantFB(snapshot: document)!)
//                       }
                   }
                }
            }
            self.rest = restaurant
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
        
        self.dish = fetchDishes
        
    }
    
    func formatPrice(price: Double) -> String {
        return "$" + (price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price))
    }

}
