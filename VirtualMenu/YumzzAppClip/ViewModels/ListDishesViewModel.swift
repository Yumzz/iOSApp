//
//  ListDishesViewModel.swift
//  YumzzAppClip
//
//  Created by Rohan Tyagi on 1/19/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation

class ListDishesViewModel: ObservableObject {
    
    var restaurant: RestaurantFB
    
    var dishCategories: [DishCategory] = []
    
    let dispatchGroup = DispatchGroup()
    let dispatchGroup2 = DispatchGroup()
    
    init(restaurant: RestaurantFB, dispatch: DispatchGroup) {
        
        self.restaurant = restaurant
        
        self.dispatchGroup.enter()
    }
    
    
    func categorizeDishes(dishes: [DishFB]) {
        var typeToDishes = Dictionary<String, [DishFB]>()
        var dishDescript = Dictionary<String, String>()
        
        for dish in dishes {
            if dish.dishCatDescription != ""{
                dishDescript[dish.type] = dish.dishCatDescription
            }
            if typeToDishes[dish.type] == nil {
                typeToDishes[dish.type] = [dish]
            } else {
                typeToDishes[dish.type]?.append(dish)
            }
        }
        
        for (category, dishes) in typeToDishes {
            if dishDescript[category] != nil {
                dishCategories.append(DishCategory(isExpanded: true, dishes: dishes, name: category, description: dishDescript[category]!))
            }
            else{
                dishCategories.append(DishCategory(isExpanded: true, dishes: dishes, name: category, description: ""))
            }
        }
        
        if !self.restaurant.builds!.isEmpty {
//            for b in self.builds {
//                dishCategories.append(DishCategory(isExpanded: <#T##Bool#>, dishes: <#T##[DishFB]?#>, builds: <#T##[BuildFB]?#>, name: <#T##String#>, description: <#T##String#>))
//            }
            dishCategories.append(DishCategory(isExpanded: true, builds: self.restaurant.builds!, name: "Build Your Own", description: ""))
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
