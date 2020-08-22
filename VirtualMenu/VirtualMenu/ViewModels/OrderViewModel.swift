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

class OrderViewModel: ObservableObject {

    let db = Firestore.firestore()
    
    @Published var restChosen: RestaurantFB = RestaurantFB.previewRest()
    @Published var dishesChosen = [DishFB]()
    
    @Published var totalCost = 0.0
    
    var dishIndexes = [DishFB : Int]()
    
    var dishRestaurant = [DishFB : RestaurantFB]()
    

    //func - add dish to order list
    func addDish(dish: DishFB, rest: RestaurantFB, dis: DispatchGroup){
        print("enter add dish")
        dishIndexes[dish] = dishesChosen.count
        dishRestaurant[dish] = rest
        dishesChosen.append(dish)
        print("leave add dish")
        dis.leave()
    }
    
    //func - delete dish from order list
    func deleteDish(dish: DishFB){
//        dishesChosen
        dishesChosen.remove(at: dishIndexes[dish]!)
        dishIndexes.removeValue(forKey: dish)
        dishRestaurant.removeValue(forKey: dish)
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
