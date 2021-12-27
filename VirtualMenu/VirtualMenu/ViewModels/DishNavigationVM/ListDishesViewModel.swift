//
//  ListDishesViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/10/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
//#if !APPCLIP
import Firebase
//#endif
var dishCache = Cache<String, DishFB>()
class ListDishesViewModel: ObservableObject {
    
    let db = Firestore.firestore()

    var restaurant: RestaurantFB
    var dishes = [DishFB]()
    var builds = [BuildFB]()
    var dishCategories: [DishCategory] = []
    
    let dispatchGroup = DispatchGroup()
    let dispatchGroup2 = DispatchGroup()

    
    
    init(restaurant: RestaurantFB, dispatch: DispatchGroup) {
        dispatch.enter()
        print("view model list dishes")
        self.restaurant = restaurant
        
        self.dispatchGroup.enter()
        
        print("fetchDishesCalled: \(self.dishes.isEmpty)")
                
        fetchDishesFB(name: restaurant.name)
        
        self.dispatchGroup.notify(queue: .main) {

            self.dispatchGroup2.enter()
            print("builds pre")
            self.fetchBuildsFB(id: restaurant.id)
            
            self.dispatchGroup2.notify(queue: .main){
                self.dishes.sort {
                    $0.name < $1.name
                }
                print("sorting")
                            
                self.categorizeDishes(dishes: self.dishes)
                
                print("catted")
                
                self.dishCategories.sort {
                    $0.name < $1.name
                }
                dispatch.leave()
            }
            
        }
        
    }
    
    func fetchBuildsFB(id: String) {
        print("build: \(id)")
        db.collection("Build").whereField("RestaurantID", isEqualTo: id).getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        print("build \(snapshot?.documents)")
                        if(!snapshot!.documents.isEmpty){
                            print("build exists")
                            for document in snapshot!.documents {
                                DispatchQueue.main.async {
                                    let build = BuildFB(snapshot: document)
        
                                    self.builds.append(build!)
//                                    print("build created for: \(name)" )
        
                                    if(document == snapshot!.documents.last){
                                        self.dispatchGroup2.leave()
                                    }
                                }
                            }
                        }else{
                            self.dispatchGroup2.leave()
                        }
                    }
                }
    }
    
    func fetchDishesFB(name: String) {
        print("fetch")
        //fetch dishes
        //restaurant.id
        //cache dishes
        print(self.restaurant.id)
        db.collection("Dish").whereField("RestaurantID", isEqualTo: self.restaurant.id.trim).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    DispatchQueue.main.async {
                        print("dish creation")
                        let n = document.data()["Name"] as! String
                        if(dishCache.value(forKey: n) != nil){
                            print("dish get \(n)")
                            self.dishes.append(dishCache.value(forKey: n)!)
                        }
                        else{
                            let dish = DishFB(snapshot: document)!
                            print("dish made \(dish.id)")
                            dishCache.insert(dish, forKey: dish.name)
                            self.dishes.append(dish)
                            
                            if(document == snapshot!.documents.last){
                                print("finished fetching dishes")
                                self.dispatchGroup.leave()
                            }
                        }
                    }
                }
            }
        }
    }
//    if(self.cache.value(forKey: n) != nil){
//        print("dish get \(n)")
//        self.dishes.append(self.cache.value(forKey: n)!)
//    }
//    else{
//        print("dish creation")
//        let dish = DishFB(snapshot: document)!
//        print("dish made \(dish.id)")
//        self.dishes.append(dish)
//        self.cache.insert(dish, forKey: dish.name)
//
//        if(document == snapshot!.documents.last){
//            print("finished fetching dishes")
//            self.dispatchGroup.leave()
//        }
//    }
    
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
        
        if !self.builds.isEmpty {
            
//            for b in self.builds {
//                dishCategories.append(DishCategory(isExpanded: <#T##Bool#>, dishes: <#T##[DishFB]?#>, builds: <#T##[BuildFB]?#>, name: <#T##String#>, description: <#T##String#>))
//            }
            dishCategories.append(DishCategory(isExpanded: true, builds: self.builds, name: "Build Your Own", description: ""))
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
