//
//  ReviewOrder.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/14/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import MQTTClient


struct ReviewOrder: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var order : OrderModel
    
    @State var dishCounts: [DishFB:Int] = [DishFB:Int]()
    
    @State var dishes: [DishFB] = [DishFB]()
    @State var dishReceipts: [(String, Double)] = [(String, Double)]()
    @State private var sendPrinterOrder = false
    
    let dispatchGroup = DispatchGroup()
    
    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    XButton(mode: self.mode)
                    Spacer().frame(width: 53, height: 0)
                    Text("Review Order")
                        .foregroundColor(ColorManager.textGray)
                        .font(.system(size: 24)).bold()
                }
                
                VStack{
                    Text("Your Order at \(self.order.restChosen.name)")
                        .foregroundColor(ColorManager.textGray)
                        .font(.system(size: 24)).bold()
                    ScrollView{
                        ForEach(self.dishes, id: \.name){ dish in
        //                    Text("\(dish.name) - \(dishCounts[dish]!)")
                            HStack{
                                DishCardOrder(count: dishCounts[dish]!, name: dish.name, price: dish.price, dish: dish)
                                
                                XButtonDelete()
                                    .onTapGesture {
                                        self.dispatchGroup.enter()
                                        self.order.deleteDish(dish: dish, dis: self.dispatchGroup)
                                        self.dispatchGroup.notify(queue: .main){
                                            self.dishCounts = self.order.dishCounts
                                            self.dishes = self.order.dishesChosen

                                        }
                                    }
                                    .frame(width: 20, height: 20, alignment: .center)
                            }
                            
                        }
                    }
                }
                
                VStack{
                    Text("Receipt")
                        .foregroundColor(ColorManager.textGray)
                        .font(.system(size: 24)).bold()
                    ReceiptCard(total: self.order.totalCost)
                }
                Spacer()
                
                HStack{
                    OrangeButton(strLabel: "Call a Waiter", width: 167.5, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                    InvertedOrangeButton(strLabel: "Send Order", width: 167.5, height: 48).clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        .shadow(radius: 5)
                        .onTapGesture {
                            self.sendPrinterOrder = true
//                            for d in self.dishes{
//                                let dishTuple: (String, Double) = (d.name, d.price)
//                                self.dishReceipts.append(dishTuple)
//                                if(d == self.dishes.last){
//                                    print("before sent to mqtt: \(self.dishReceipts)")
//                                    self.sendPrinterOrder = true
//                                    print("sendorder: \(self.sendPrinterOrder)")
//                                }
//                            }
                        }
                }
                Spacer()
            }

        }.navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButton(mode: self.mode))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(){
            self.dishCounts = self.order.dishCounts
            self.dishes = self.order.dishesChosen
            //create notification center observer
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "OrderSent"), object: nil, queue: .main) { (Notification) in
                self.order.orderSent()
            }
        }
        .sheet(isPresented: $sendPrinterOrder){
            ClientConnection(dishes: self.dishes)
        }
    }
}

