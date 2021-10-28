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
    @State private var IoT = false
    @State private var sendPrinterOrder = false
    @State private var callWaiter = false
    @State var changeInstructions = false
    @State var dish: DishFB = DishFB.previewDish()
    
    let dispatchGroup = DispatchGroup()
    
    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading){
                VStack{
                    HStack{
                        BackButton(mode: self.mode)
//                        #if !APPCLIP
//                        XButton(mode: self.mode)
//                        #endif
                        Text("Your Order")
                            .foregroundColor(ColorManager.textGray)
                            .font(.system(size: 24)).bold().padding(.horizontal)
                    }
                    ScrollView(.vertical){
                        ForEach(self.dishes, id: \.name){ dish in
        //                    Text("\(dish.name) - \(dishCounts[dish]!)")
                            VStack{
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
                                    
    //                                Spacer().frame(width:20)
                                }
                                VStack{
                                    Group{
                                        if(self.order.optsChosen[dish] != nil){
                                        HStack(alignment: .center){
    //                                        if(self.order.optsChosen[dish] != nil){
                                                ScrollView(.horizontal){
                                                    HStack(alignment: .center, spacing: 2){
                                                        Text("Added:")
                                                            .font(.system(size: 10))
                                                        ForEach(self.order.optsChosen[dish]!, id: \.self){ option in
                                                            if(option == self.order.optsChosen[dish]?.last){
                                                                Text(option)
                                                                    .foregroundColor(.white)
                                                                    .font(.system(size: 10))
                                                            }
                                                            else{
                                                                Text("\(option),")
                                                                    .foregroundColor(.black)
                                                                    .font(.system(size: 10))
                                                            }
                                                        }
                                                    }
                                                }
    //                                        }
                                        }
                                        .frame(maxWidth: UIScreen.main.bounds.width/2, alignment: .leading)
                                        .frame(height: 20)
                                        .background(ColorManager.textGray)
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
    //                                    .scaledToFit()
                                        }
                                        
                                    }
    //                                Group {
                                    if(self.order.dishChoice[dish]! != ""){
                                        HStack(alignment: .center){
    //                                        if(self.order.dishChoice[dish]! != ""){
                                            ScrollView(.horizontal){
                                                HStack(alignment: .center, spacing: 2){
                                                    Text("Instructions: \(self.order.dishChoice[dish]!)")
                                                        .font(.system(size: 10)).foregroundColor(.white).background(ColorManager.yumzzOrange)
                                                }
                                            }
                                            Image(systemName: "pencil")
                                                .onTapGesture{
                                                    self.dish = dish
                                                    self.changeInstructions = true
                                                }
//                                                .colorScheme(ColorManager.yumzzOrange)
//                                                .fixedSize(horizontal: 10, vertical: 10)
    //                                        }
                                        }.frame(maxWidth: UIScreen.main.bounds.width/2, alignment: .leading)
                                        .frame(height: 20)
                                        .background(ColorManager.textGray)
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                        
    //                                    .scaledToFit()
    //                                }
                                    }
                                }
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
                

                #if !APPCLIP
                HStack{
                    OrangeButton(strLabel: "Call a Waiter", width: 167.5, height: 48)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        .onTapGesture {
                            self.callWaiter = true
                            self.IoT = true
                        }
                    Spacer()
                    InvertedOrangeButton(strLabel: "Send Order", width: 167.5, height: 48).clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        .shadow(radius: 5)
                        .onTapGesture {
                            self.sendPrinterOrder = true
                            self.IoT = true
                        }
                }.padding(.horizontal)
                #else
                HStack{
                    InvertedOrangeButton(strLabel: "Send Order", width: UIScreen.main.bounds.width - 40, height: 48).clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                    .shadow(radius: 5)
                    .onTapGesture {
                        self.sendPrinterOrder = true
                        self.IoT = true
                    }
            }.padding(.horizontal)

                
                #endif
                Spacer()
            }

        }
        .navigationBarTitle("Review \(self.order.restChosen.name) Order")
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
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "WaiterCalled"), object: nil, queue: .main) { (Notification) in
//                self.order.orderSent()
                print("wow")
            }
        }
        .sheet(isPresented: $IoT){
            if(self.sendPrinterOrder){
                ClientConnection(dishes: self.dishes, quantity: self.order.dishCounts, rest: self.order.restChosen)
            }
            #if !APPCLIP
                if(self.callWaiter){
                    WaiterConnection()
                }
            #endif
            
//            ClientConnection(dishes: self.dishes, quantity: self.order.dishCounts, rest: self.order.restChosen)
        }
        .alert(isPresented: $changeInstructions, TextFieldAlert(title: "Edit Special Instructions?", message: "\(self.dish.name) - \(self.dish.description)") { (text) in
                    if text != nil {
                        print(text)
                        if((self.order.dishChoice[self.dish]?.isEmpty) != nil){
                            self.order.dishChoice[self.dish] = ""
                        }
                        var newText = text?.replacingOccurrences(of: ";", with: ",")
                        self.order.dishChoice[self.dish] = newText!
                        
                        print(self.order.dishChoice[self.dish])
//                        self.saveGroup(text: text!)
//                        self.addtapped = true
                    }
                    print("alert here now")
//                    self.addtapped = true
                })
    }
}

