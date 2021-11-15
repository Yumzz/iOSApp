//
//  PastOrdersViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/14/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase


class PastOrdersViewModel: ObservableObject{
    
//    @EnvironmentObject var order : OrderModel
    var pastOrders = [Order]()
//    var dpa: DispatchGroup = DispatchGroup()

    
    func retrieveOrders(userID: String, dispatch: DispatchGroup){
//        dispatch.enter()
//        print("stay")
        let db = Firestore.firestore()
        let orderQuery = db.collection("Order").whereField("userId", isEqualTo: userID)
        var orders : [Order] = []
        //1. go through each order for this user
        //2. construct each order with its' list of dishes
        //3. add all orders to prevOrders
        var count = 0
        orderQuery.getDocuments { (snap, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            else{
                
                for doc in snap!.documents {
                    let ds = DispatchGroup()
                    ds.enter()
//                    print("ordercount: \(snap!.documents.count)")
                    let dishes: [DocumentReference] = doc.data()["dishes"] as! [DocumentReference]
                    let time: Timestamp = doc.data()["time"] as! Timestamp
                    let t = time.dateValue()
                    let rest: String = doc.data()["rest"] as! String
                    let specInstruct: String = doc.data()["instruct"] as! String
                    let total: String = doc.data()["totalPrice"] as! String
                    var dish = DishFB.previewDish()
                    let dpatch = DispatchGroup()
                    
                    //need to create order
                    var diss: [DishFB] = []
                    count = 0
                    for d in dishes {
//                        self.dpa.enter()
                        d.getDocument{ (document, error) in
                            if let document = document, document.exists {
                                print("countdish: \(count) dish: \(document.data()!["Name"]) inst: \(specInstruct)")
                                count += 1
                                let a = document.data()
                                dpatch.enter()
                                DispatchQueue.main.async{
                                    dish = DishFB(json: a!, dis: dpatch)!
                                    dpatch.notify(queue: .main){
                                        diss.append(dish)
                                        print("dishcountu: \(diss.count) ")
                                        if(d == dishes.last){
                                            let id = doc.documentID
                                            print("finaldishcountu: \(diss.count) id: \(id)")
                //                                        self.dpa.leave()
                                            orders.append(Order(dishes: diss, totalPrice: Double(total)!, rest: rest, id: id, time: t, specialInstruc: specInstruct))
                                            self.pastOrders = orders
                                            print("ododo: \(diss)")
                                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PastOrders"), object: orders)
                                            ds.leave()
                                            
                                        }
                                    }
                                }
                                
                                
                            }
                            else{
                                print("Document does not exist")
                            }
                            
                        }
                    }
                    ds.notify(queue: .main){
                        if(doc == snap!.documents.last){
                            print("got all orders")
                            print(orders)
    //                      self.makeOrder(orders: dishes, ds2: ds2)
                            print(self.pastOrders)
                            
                            self.pastOrders = orders
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PastOrders"), object: orders)
                        }
                    }
//                    self.dpa.notify(queue: .main){
//                        print("orderlas")
                
//                    }
                }
            }
            
        }
        
    }
    
    func fetchPastOrders(disp: DispatchGroup){
        if(userProfile.userId != ""){
//            print("stay-before")
            self.retrieveOrders(userID: userProfile.userId, dispatch: disp)
        }
    }
    
    init(dispatch: DispatchGroup){
        self.fetchPastOrders(disp: dispatch)
        print("view model past orders")
    }
    
    
    
    
}
