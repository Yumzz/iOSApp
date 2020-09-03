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
    
    var pastOrders = [Order]()
    
    
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
                    let data = ["dishes": self.dishReferences, "userId": userProfile.userId, "rest": self.restChosen.name] as [String : Any]
                    let reference = db.collection("Order").addDocument(data: data)
                    print("posted order")
                    self.dishReferences = [DocumentReference]()
    //                                self.addOrder(ref: reference)
                    self.retrieveOrders(userID: userProfile.userId)
                }
            }
        }
    }
    
    func retrieveOrders(userID: String){
        let db = Firestore.firestore()
        let orderQuery = db.collection("Order").whereField("userId", isEqualTo: userID)
        let ds = DispatchGroup()
        var orderss : Set<[DocumentReference]> = Set<[DocumentReference]>()
        //1. go through each order for this user
        //2. construct each order with its' list of dishes
        //3. add all orders to prevOrders
        orderQuery.getDocuments { (snap, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            else{
                ds.enter()
                print("got order doc")
                for doc in snap!.documents {
                    //int to dish list and send that to function afet ds.notify?
                    let dishes: [DocumentReference] = doc.data()["dishes"] as! [DocumentReference]
                    //need to create order
                    orderss.insert(dishes)
                    print("got dishes")
                    if(doc == snap!.documents.last){
                        ds.leave()
                        ds.notify(queue: .main){
                            print("got all orders")
                            let ds2 = DispatchGroup()
                            print(orderss)
                            self.makeOrder(orders: orderss, ds2: ds2)
                            print(self.pastOrders)
                        }
                    }
                }
            }
            
        }
        
    }
    
    func makeOrder(orders: Set<[DocumentReference]>, ds2: DispatchGroup){
//        var order = Order(dishes: [], totalPrice: 0.0)
        for ord in orders {
            var order = Order(dishes: [], totalPrice: 0.0, rest: "")
            print("going through each order")
            ds2.enter()
            for d in ord {
                d.getDocument { (snap2, err2) in
                    if let err2 = err2 {
                        print(err2.localizedDescription)
                    }
                    else{
                        print("dish exists in order: \(snap2!.data()!["Name"] as! String)")
                        let price = Double(snap2!.data()!["Price"] as! String)
                        let dish = DishFB(name: snap2!.data()!["Name"] as! String, description: snap2!.data()!["Description"] as! String, price: price!, type: snap2!.data()!["Type"] as! String, restaurant: snap2!.data()!["Restaurant"] as! String)
                        order.dishes.append(dish)
                        order.totalPrice = order.totalPrice + dish.price
                        
                        if(d == ord.last){
                            print("last dish in order")
                            order.rest = snap2!.data()!["Restaurant"] as! String
                            ds2.leave()
                            ds2.notify(queue: .main){
                                self.pastOrders.append(order)
                                print(self.pastOrders)
                            }
                        }
                    }
                }
            }
        }
      }
}
