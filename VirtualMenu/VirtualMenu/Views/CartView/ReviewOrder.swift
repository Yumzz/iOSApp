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
                            DishCardOrder(count: dishCounts[dish]!, name: dish.name, price: dish.price)
                            
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
                    InvertedOrangeButton(strLabel: "Add to Order", width: 167.5, height: 48).clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
                        .shadow(radius: 5)
                }
                Spacer()

            }

        }.navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButton(mode: self.mode))
        .onAppear(){
            for x in self.order.dishesChosen{
                if(dishCounts[x] != nil){
                    ("dish added: \(x.name)")
                    dishCounts[x] = dishCounts[x]! + 1
                }
                else{
                    ("dish new: \(x.name)")
                    dishes.append(x)
                    dishCounts[x] = 1
                }
            }
        }
    }
}

