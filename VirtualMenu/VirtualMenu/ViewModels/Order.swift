//
//  OrderViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/20/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import CloudKit
import Firebase
import MapKit

class Order: ObservableObject {

    let db = Firestore.firestore()

    @Published var restChosen: RestaurantFB
    @Published var dishesChosen: [DishFB]
    
    @Published var totalCost: Double
    
    
    //do i want these attributes to cause an update when they change
    var dishIndexes : [DishFB : Int]
    
    var dishRestaurant : [DishFB : RestaurantFB]
    
    init() {
        //TODO: initialize to false if the user logged in before
        self.restChosen = RestaurantFB.previewRest()
        self.dishesChosen = [DishFB]()
        self.dishIndexes = [DishFB : Int]()
        self.dishRestaurant = [DishFB : RestaurantFB]()
        self.totalCost = 0.0
    }

    //func - add dish to order list
    func addDish(dish: DishFB, rest: RestaurantFB, dis: DispatchGroup){
        dishIndexes[dish] = dishesChosen.count
        dishRestaurant[dish] = rest
        dishesChosen.append(dish)
        self.totalCost = self.totalCost + dish.price
        dis.leave()
    }
    
    //func - delete dish from order list
    func deleteDish(dish: DishFB){
//        dishesChosen
        dishesChosen.remove(at: dishIndexes[dish]!)
        dishIndexes.removeValue(forKey: dish)
        dishRestaurant.removeValue(forKey: dish)
        self.totalCost = self.totalCost - dish.price
    }
    
    //func - total the amount
    func totalAmount(){
        for dish in self.dishesChosen{
            self.totalCost = self.totalCost + dish.price
        }
    }
    
    //func - get restaurant
    func getRestaurant(dish: DishFB) -> RestaurantFB{
        self.restChosen = dishRestaurant[dish]!
        return self.restChosen
    }
    
}
