//
//  ReviewOrder.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/14/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI


struct ReviewOrder: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var order : OrderModel
    
    @State var dishCounts: [DishFB:Int] = [DishFB:Int]()
    
    @State var dishes: [DishFB] = [DishFB]()
    
    let dispatchGroup = DispatchGroup()
    
    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading){
                HStack{
                 
                    XButton(mode: self.mode)
//                    Spacer()
//                    Spacer().frame(width: 53, height: 0)
                    Text("Review Order")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(ColorManager.textGray)
                        .font(.system(size: 24, weight: .bold))
//                    Spacer()
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
                                
                                Spacer().frame(width:20)
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
                
                VStack(alignment: .center){
                    HStack{
                        Spacer()
                        OrangeButton(strLabel: "Call a Waiter", width: 167.5, height: 48)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        InvertedOrangeButton(strLabel: "Add to Order", width: 167.5, height: 48).clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                            .shadow(radius: 5)
                        Spacer()
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
        }
    }
}

