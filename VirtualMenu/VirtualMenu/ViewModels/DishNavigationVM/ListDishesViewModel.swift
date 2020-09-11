//
//  ListDishesViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/10/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

class ListDishesViewModel: ObservableObject {
    
    let db = Firestore.firestore()

    var restaurant: RestaurantFB
    var dishes = [DishFB]()
    var dishCategories: [DishCategory] = []
    
    let dispatchGroup = DispatchGroup()
    

    
    
    init(restaurant: RestaurantFB) {
        
        self.restaurant = restaurant
        
        self.dispatchGroup.enter()
                
        fetchDishesFB(name: restaurant.name)
        
        self.dispatchGroup.notify(queue: .main) {

            self.dishes.sort {
                $0.name < $1.name
            }
            print("sorting")
                        
            self.categorizeDishes(dishes: self.dishes)
            
            print("catted")
            
            self.dishCategories.sort {
                $0.name < $1.name
            }
            
        }
        
        
    }
    
    func fetchDishesFB(name: String) {
        db.collection("Dish").whereField("Restaurant", isEqualTo: name).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    DispatchQueue.main.async {
                        let dish = DishFB(snapshot: document)!
                        self.dishes.append(dish)
                        
                        if(document == snapshot!.documents.last){
                            self.dispatchGroup.leave()
                        }
                    }
                }
            }
        }
    }
    
    func categorizeDishes(dishes: [DishFB]) {
        var typeToDishes = Dictionary<String, [DishFB]>()
        
        for dish in dishes {
            if typeToDishes[dish.type] == nil {
                typeToDishes[dish.type] = [dish]
            } else {
                typeToDishes[dish.type]?.append(dish)
            }
        }
        
        for (category, dishes) in typeToDishes {
            dishCategories.append(DishCategory(isExpanded: true, dishes: dishes, name: category))
        }
    }
    
    func formatPrice(price: Double) -> String {
        var x =  "$" + (price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price))
        if(x.numOfNums() < 3){
            x = x + "0"
        }
        return x
    }
    
}
