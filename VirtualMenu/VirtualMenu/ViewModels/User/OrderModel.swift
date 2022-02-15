//
//  OrderViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/20/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import CloudKit
#if !APPCLIP
import Firebase
#endif
import MapKit
import Foundation

class OrderModel: ObservableObject {

    #if !APPCLIP
    let db = Firestore.firestore()
    var dishReferences = [DocumentReference]()
    #endif
    @Published var restChosen: RestaurantFB = RestaurantFB.previewRest()
    @Published var dishesChosen: [DishFB] = []
    @Published var buildsChosen: [BuildFB] = []
    
    @Published var totalCost: Double = 0.0
    
    var pastOrders = [Order]()
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    //do i want these attributes to cause an update when they change
    var dishIndexes : [DishFB : Int] = [DishFB : Int]()
    var dishCounts : [DishFB : Int] = [DishFB : Int]()
    var optsChosen: [DishFB: [String]] = [DishFB: [String]]()
    
    var buildIndexes : [BuildFB : Int] = [BuildFB : Int]()
    var buildCounts : [BuildFB : Int] = [BuildFB : Int]()
    var buildOptsChosen: [BuildFB: [String]] = [BuildFB: [String]]()
    
    var dishChoice : [DishFB: String] = [DishFB.previewDish(): ""]
    var buildChoice : [BuildFB: String] = [BuildFB.previewBuild(): ""]
    //["Substitute": 0, "Choice of": 1, "Add": 2]
    var currentOrder: Order = Order.previewOrder()

    var allDishes: Int
    var allBuilds: Int
//    var dishRestaurant : [DishFB : RestaurantFB] = [DishFB : RestaurantFB]()
    
    init() {
        //TODO: initialize to false if the user logged in before
        self.restChosen = RestaurantFB.previewRest()
        self.dishesChosen = [DishFB]()
        self.dishIndexes = [DishFB : Int]()
        self.dishCounts = [DishFB : Int]()
        self.allDishes = 0
        self.allBuilds = 0
        self.totalCost = 0.0
    }

    //func - add dish to order list
    func addDish(dish: DishFB, rest: RestaurantFB, dis: DispatchGroup){
        //need to check if same restaurant, if not then signify alert saying order created will be deleted and started over
        if(rest.name == self.restChosen.name || self.restChosen.name == ""){
            self.allDishes += 1
            if(dishCounts[dish] == nil){
                dishIndexes[dish] = dishesChosen.count
                dishesChosen.append(dish)
                dishCounts[dish] = 1
            }
            else{
                dishCounts[dish] = dishCounts[dish]! + 1
            }
            self.totalAmount()
            if(self.optsChosen[dish] != nil){
                for x in self.optsChosen[dish]!{
                    self.totalCost += Double(dish.options[x]!)
                }
            }
            dis.leave()
        }
        else{
            //need to delete order and start anew w new rest
            self.newOrder(rest: rest)
            self.allDishes = 1
            dishIndexes[dish] = dishesChosen.count
            dishesChosen.append(dish)
            dishCounts[dish] = 1
            self.totalAmount()
            if(self.optsChosen[dish] != nil){
                for x in self.optsChosen[dish]!{
                    self.totalCost += Double(dish.options[x]!)
//                    self.currentOrder.specialInstruc[dish] = self.order.dishChoice[dish]
                }
            }
            self.currentOrder.dishes = self.dishesChosen
            
            dis.leave()
        }
    }
    
    func addBuildOwn(build: BuildFB, rest: RestaurantFB, dis: DispatchGroup, total: Double, optionsChosen: Set<String>){
        if(rest.name == self.restChosen.name || self.restChosen.name == ""){
            self.allBuilds += 1
            if(buildCounts[build] == nil){
                buildIndexes[build] = buildCounts.count
                buildsChosen.append(build)
                buildCounts[build] = 1
            }
            else{
                buildCounts[build] = buildCounts[build]! + 1
            }
            self.totalAmount()
            if(!optionsChosen.isEmpty){
                self.buildOptsChosen[build] = Array(optionsChosen)
            }
            dis.leave()
        }
        else{
            self.newOrder(rest: rest)
            self.allBuilds = 1
        }
    }
    
    func checkSameRest(dish: DishFB) -> Bool{
        if(restChosen.name != ""){
            if(dish.restaurant != self.restChosen.name){
                return false
            }else{
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
        // print("dishIndexes: \(dishIndexes[dish])")
//        dis.leave()
        if(allDishes == 1){
            dishesChosen.removeAll()
            dishIndexes.removeAll()
            allDishes = 0
            dishCounts.removeAll()
        }
        else{
            allDishes = allDishes - 1
            dishCounts[dish] = dishCounts[dish]! - 1
            if(dishCounts[dish] == 0){
                var index = dishIndexes[dish]! + 1
                //every dish after this one needs to have dishIndex for them go down by 1 each
                while index < dishesChosen.count {
        //            dishIndexes[]
        //            dishesChosen.get
                    let dish = dishesChosen[index]
                    dishIndexes[dish] = dishIndexes[dish]! - 1
                    index = index + 1
                }
                dishesChosen.remove(at: dishIndexes[dish]!)
                dishIndexes.removeValue(forKey: dish)
                dishCounts.removeValue(forKey: dish)
            }
        }
        
        self.totalAmount()
        print("leave")
        dis.leave()
//        let x = DishFB.formatPrice(price: self.totalCost - dish.price)
    }
    
    func deleteBuild(build: BuildFB, dis: DispatchGroup){
        if(allBuilds == 1){
            buildsChosen.removeAll()
            buildIndexes.removeAll()
            allBuilds = 0
            buildCounts.removeAll()
        }
        else{
            allBuilds = allBuilds - 1
            buildCounts[build] = buildCounts[build]! - 1
            if(buildCounts[build] == 0){
                var index = buildIndexes[build]! + 1
                //every dish after this one needs to have dishIndex for them go down by 1 each
                while index < buildsChosen.count {
        //            dishIndexes[]
        //            dishesChosen.get
                    let build = buildsChosen[index]
                    buildIndexes[build] = buildIndexes[build]! - 1
                    index = index + 1
                }
                buildsChosen.remove(at: buildIndexes[build]!)
                buildIndexes.removeValue(forKey: build)
                buildCounts.removeValue(forKey: build)
            }
        }
        self.totalAmount()
        print("leave")
        dis.leave()
    }
    
    //func - total the amount
    func totalAmount(){
        self.totalCost = 0.00
        for dish in self.dishesChosen{
//            print("price: \(dish.price)")
            let x = self.totalCost + dish.price
            self.totalCost = Double(round(1000*x)/1000)
        }
        for build in self.buildsChosen{
//            print("price: \(dish.price)")
            let x = self.totalCost + build.basePrice
//            for p in self.build.priceOpts {
//
//            }
            self.totalCost += Double(round(1000*x)/1000)
        }
        
        
//        print("total: \(self.totalCost)")
    }
    
    //func - get restaurant
    func getRestaurant(dish: DishFB) -> RestaurantFB{
        return self.restChosen
    }
    
    func newOrder(rest: RestaurantFB){
        self.restChosen = rest
        self.dishIndexes = [DishFB : Int]()
        self.dishesChosen = [DishFB]()
        self.optsChosen.removeAll()
        self.allDishes = 0
        self.totalCost = 0.0
        self.currentOrder = Order(dishes: self.dishesChosen, totalPrice: self.totalCost, rest: rest.name)
    }
    
    
    func orderSent(){
        self.pastOrders.append(Order(dishes: self.dishesChosen, totalPrice: self.totalCost, rest: self.restChosen.name))
        self.dishesChosen = []
        self.buildsChosen = []
        self.dishIndexes = [DishFB : Int]()
        self.dishCounts = [DishFB : Int]()
        self.optsChosen = [DishFB: [String]]()
        self.buildCounts = [BuildFB : Int]()
        self.buildIndexes = [BuildFB : Int]()
        self.buildOptsChosen = [BuildFB: [String]]()
        self.allDishes = 0
        self.totalCost = 0.0
        self.currentOrder = Order.previewOrder()
        //save past order to firebase
    }
    
    #if !APPCLIP
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
                        self.dishReferences.append(document.reference)
                        if(document == snap!.documents.last){
                            ds.leave()
                        }
                    }
                }
            }
            ds.notify(queue: .main){
                if(d == order.dishes.last){
                    let data = ["dishes": self.dishReferences, "userId": userProfile.userId, "rest": self.restChosen.name, "time": order.time, "instruct": order.specialInstruc, "totalPrice": String(order.totalPrice)] as [String : Any]
                    db.collection("Order").addDocument(data: data)
                    self.dishReferences = [DocumentReference]()
    //                                self.addOrder(ref: reference)
//                    self.retrieveOrders(userID: userProfile.userId)
                }
            }
        }
    }
    
    func retrieveOrders(userID: String, dispatch: DispatchGroup){
//        dispatch.enter()
        let db = Firestore.firestore()
        let orderQuery = db.collection("Order").whereField("userId", isEqualTo: userID)
        let ds = DispatchGroup()
//        var dishes : Set<[DocumentReference]> = Set<[DocumentReference]>()
        var orders : [Order] = [Order.previewOrder()]
        //1. go through each order for this user
        //2. construct each order with its' list of dishes
        //3. add all orders to prevOrders
        orderQuery.getDocuments { (snap, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            else{
                ds.enter()
                for doc in snap!.documents {
                    //int to dish list and send that to function afet ds.notify?
                    let dishes: [DocumentReference] = doc.data()["dishes"] as! [DocumentReference]
                    let time: Date = doc.data()["time"] as! Date
                    let rest: String = doc.data()["rest"] as! String
                    let specInstruct: String = doc.data()["instruct"] as! String
                    let total: String = doc.data()["totalPrice"] as! String
                    //need to create order
                    var diss: [DishFB] = []
                    for d in dishes {
                        d.getDocument{ (document, error) in
                            if let document = document, document.exists {
                                let a = document.data()
//                                DishFB(
                                let c = DishFB(json: a!, dis: dispatch)
                                dispatch.notify(queue: .main){
                                    diss.append(c!)
                                }
                            }
                            else{
                                print("Document does not exist")
                            }
//                            diss.append(DishFB(snapshot: document.data())!)
                            
                        }
                    }
                    
                    orders.insert(Order(dishes: diss, totalPrice: Double(total)!, rest: rest, id: doc.documentID, time: time, specialInstruc: specInstruct), at: orders.count)
                    if(doc == snap!.documents.last){
                        ds.leave()
                        ds.notify(queue: .main){
                            print("got all orders")
                            let ds2 = DispatchGroup()
                            print(orders)
//                            self.makeOrder(orders: dishes, ds2: ds2)
                            print(self.pastOrders)
                            dispatch.leave()
                        }
                    }
                }
            }
            
        }
        
    }
    
//    func makeOrder(dishes: [DocumentReference], time: Date, ds2: DispatchGroup){
//        var order = Order(dishes: [], totalPrice: 0.0, rest: "", time: Date(), specialInstruc: "")
//        for ord in dishes {
//            ds2.enter()
//            for d in ord {
//                d.getDocument { (snap2, err2) in
//                    if let err2 = err2 {
//                        print(err2.localizedDescription)
//                    }
//                    else{
//                        let price = Double(snap2!.data()!["Price"] as! String)
//                        let dish = DishFB(name: snap2!.data()!["Name"] as! String, description: snap2!.data()!["Description"] as! String, price: price!, type: snap2!.data()!["Type"] as! String, restaurant: snap2!.data()!["Restaurant"] as! String)
//                        order.dishes.append(dish)
//                        order.totalPrice = order.totalPrice + dish.price
//
//                        if(d == ord.last){
//                            order.rest = snap2!.data()!["Restaurant"] as! String
//                            ds2.leave()
//                            ds2.notify(queue: .main){
//                                self.pastOrders.append(order)
//                                print(self.pastOrders)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//      }
    
    #endif
    
    func formatPrice(price: Double) -> String {
        var x =  "$" + (price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price))
        if(x.numOfNums() < 3){
            x = x + "0"
        }
        return x
    }
}

func getDateOnly(fromTimeStamp timestamp: TimeInterval) -> String {
  let dayTimePeriodFormatter = DateFormatter()
  dayTimePeriodFormatter.timeZone = TimeZone.current
  dayTimePeriodFormatter.dateFormat = "MMMM dd, yyyy - h:mm:ss a z"
  return dayTimePeriodFormatter.string(from: Date(timeIntervalSince1970: timestamp))
}
