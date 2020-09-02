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

class OrderModel: ObservableObject {

    let db = Firestore.firestore()

    @Published var restChosen: RestaurantFB = RestaurantFB.previewRest()
    @Published var dishesChosen: [DishFB] = []
    
    @Published var totalCost: Double = 0.0
    
    var dishReferences = [DocumentReference]()
    
    
    //do i want these attributes to cause an update when they change
    var dishIndexes : [DishFB : Int] = [DishFB : Int]()
    
    var dishRestaurant : [DishFB : RestaurantFB] = [DishFB : RestaurantFB]()
    
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
        //need to check if same restaurant, if not then signify alert saying order created will be deleted and started over
        dishIndexes[dish] = dishesChosen.count
        dishRestaurant[dish] = rest
        dishesChosen.append(dish)
        self.totalAmount()
        dis.leave()
    }
    
    func checkSameRest(dish: DishFB) -> Bool{
        print("here")
        if(restChosen.name != ""){
            print("not first chosen")
            if(dish.restaurant != self.restChosen.name){
                print("not same name")
                return false
            }else{
                print("same name")
                return true
            }
        }else{
            return true
        }
        
    }
    
    //func - delete dish from order list
    func deleteDish(dish: DishFB, dis: DispatchGroup){
//        dishesChosen
//        if(dishIndexes[dish])
        print("dishIndexes: \(dishIndexes[dish])")
        if(dishesChosen.count == 1){
            dishesChosen.removeAll()
            dishIndexes.removeAll()
            dishRestaurant.removeAll()
        }
        else{
            var index = dishIndexes[dish]! + 1
            dishesChosen.remove(at: dishIndexes[dish]!)
            //every dish after this one needs to have dishIndex for them go down by 1 each
            while index < dishesChosen.count {
    //            dishIndexes[]
    //            dishesChosen.get
                let dish = dishesChosen[index]
                dishIndexes[dish] = dishIndexes[dish]! - 1
                index = index + 1
            }

            dishIndexes.removeValue(forKey: dish)
            dishRestaurant.removeValue(forKey: dish)
        }
        self.totalAmount()
        dis.leave()
//        let x = DishFB.formatPrice(price: self.totalCost - dish.price)
    }
    
    //func - total the amount
    func totalAmount(){
        self.totalCost = 0.0
        for dish in self.dishesChosen{
            self.totalCost = self.totalCost + dish.price
        }
    }
    
    //func - get restaurant
    func getRestaurant(dish: DishFB) -> RestaurantFB{
        self.restChosen = dishRestaurant[dish]!
        return self.restChosen
    }
    
    func newOrder(rest: RestaurantFB){
        self.restChosen = rest
        self.dishIndexes = [DishFB : Int]()
        self.dishesChosen = [DishFB]()
        self.dishRestaurant = [DishFB : RestaurantFB]()
        self.totalCost = 0.0
    }
    
    
    func saveOrder(order: Order){
        let ds = DispatchGroup()
        print("save")
        let db = Firestore.firestore()
//      1. go through each dish in order
//      2. for each dish, get reference and append onto self.dishReferences
//      3. create new order on FB with dishes = self.dishReferences
        for d in order.dishes{
            let dishQuery = db.collection("Dish").whereField("Restaurant", isEqualTo: self.restChosen.name)
                .whereField("Name", isEqualTo: d.name)
            ds.enter()
            print("dishQuery: \(d.name)")
            dishQuery.getDocuments { (snap, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                }else{
                    for document in snap!.documents {
                        print(document.data())
                        self.dishReferences.append(document.reference)
                        ds.leave()
                    }
                }
            }
            ds.notify(queue: .main){
                if(d == order.dishes.last){
                    print("last: \(d.name)")
                    print(self.dishReferences)
                    let data = ["dishes": self.dishReferences, "userId": userProfile.userId] as [String : Any]
                    let reference = db.collection("Order").addDocument(data: data)
                    print("posted order")
                    self.dishReferences = [DocumentReference]()
    //                                self.addOrder(ref: reference)
                }
            }
        }
    }
    
//    func addOrder(ref: DocumentReference){
//        print("userQuery")
//        let userQuery = db.collection("User").whereField("id", isEqualTo: userProfile.userId)
//        userQuery.getDocuments { (snap, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            }else{
//                for document in snap!.documents {
////                    document.data().updateValue(<#T##value: Any##Any#>, forKey: <#T##String#>)
//
//                    var orders: [DocumentReference?] = document.data()["orders"] as! [DocumentReference?]
//                    if(orders == nil){
//                        //add orders field and populate
//                        document.setValue([ref], forKeyPath: "orders")
//                    }else{
//                        orders.append(ref)
//                        document.setValue(orders, forKeyPath: "orders")
////                        document.data().updateValue(orders, forKey: "orders")
//                    }
//                }
//            }
//        }
//    }
    
    func retrieveOrder(){
        
    }
    
    
}
