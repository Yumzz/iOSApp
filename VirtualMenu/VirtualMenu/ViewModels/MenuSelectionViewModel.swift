//
//  MenuSelectionViewModel.swift
//  VirtualMenu
//
//  Created by William Bai on 9/3/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

class MenuSelectionViewModel: ObservableObject {
    var restaurant: RestaurantFB
    @Published var featuredDishes = [DishFB]()
    
    init(restaurant: RestaurantFB) {
        self.restaurant = restaurant
        fetchFeaturedDishes()
    }
    
    func fetchFeaturedDishes() {
        let featuredDishRefs = self.restaurant.featuredDishRefs
        for dishRef in featuredDishRefs {
            dishRef!.getDocument { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    let dish = DishFB.init(snapshot: snapshot!) ?? nil
                    if dish != nil {
                        self.featuredDishes.append(dish!)
                    }
                }
            }
        }
    }
    
}
