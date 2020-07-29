//
//  ListDishesViewModel.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 04/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import CloudKit
import Firebase

class ListDishesViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var dish = [DishFB]()
    
    @Published var rest: RestaurantFB? = nil
    
    func fetchRestaurantFB(name: String){
        var restaurant: RestaurantFB? = nil
        db.collection("Restaurant").getDocuments { (rests, error) in
        if let error = error {
               print("Error getting documents: \(error)")
           } else {
               for document in rests!.documents {
                   print("\(document.documentID) => \(document.data())")
//                if(document.get("Name") == name){
                       restaurant = (RestaurantFB(snapshot: document)!)
//                   }
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
