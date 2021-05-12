//
//  DishCard.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 31/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct DishCard: View {
    
    #if !APPCLIP
    var urlImage:FBURLImage?
    #endif
    var dishName: String
    var dishIngredients: String
    var price: String
    var singPrice: Bool
    var rest: RestaurantFB
    
    var dish: DishFB
    
    let dispatchGroup = DispatchGroup()
    
//    @State private var alertMessage = ""
//    @State private var alertTitle = ""
    
    
    #if !APPCLIP
    @EnvironmentObject var order : OrderModel
    #endif
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    var body: some View {
        Group {
            HStack(alignment: .center, spacing: 10) {
                
                Spacer()
                    .frame(width: 4)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(dishName).bold()
                        .foregroundColor(Color.primary)
                    
                    Text(dishIngredients)
                        .foregroundColor(Color.secondary)
                        .font(.system(size: 14))
                        
                    Text(price)
                        .foregroundColor(Color(UIColor().colorFromHex("#C4C4C4", 1)))
                        .font(.system(size: 14))
                }
                
                Spacer()
                
                #if !APPCLIP
                if !dish.photoExists {
                    EmptyView().foregroundColor(.white)
                }
                else {
                    urlImage!
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                #endif
                
                Spacer().frame(width: 8, height: 0)
                
                #if !APPCLIP
                ZStack {
                    Rectangle()
                        .fill(Color("YumzzOrange"))
                        .frame(width: 20, height: 6)
                    
                    Rectangle()
                        .fill(Color("YumzzOrange"))
                        .frame(width: 6, height: 20)
                }
                .onTapGesture {
                        print("added")
                        if(!self.order.checkSameRest(dish: self.dish)){
//                            self.alertTitle = "Different Restaurant"
//                            self.alertMessage = "A new order has been started for \(self.rest.name)"
//                            self.showingAlert.toggle()
                            self.order.newOrder(rest: self.rest)
                        }else{
//                            self.alertTitle = "Dish Added"
//                            self.alertMessage = "A new dish has been added to your order. Check the order tab to see your entire order."
//                            self.showingAlert.toggle()
                        }
                        self.dispatchGroup.enter()
                        self.order.restChosen = self.rest
                        self.order.addDish(dish: self.dish, rest: self.rest, dis: self.dispatchGroup)
                        self.dispatchGroup.notify(queue: .main){
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Alert"), object: singPrice)
                        }
                    }
                #endif
                
                Spacer().frame(width: 15, height: 0)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 112)
            .background(Color(.white))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

//struct DishCard_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            DishCard(urlImage: nil, dishName: "Tomato Pasta", dishIngredients: "Pasta, Tomato Sauce", price: "$10", rest: RestaurantFB.previewRest(), dish: DishFB.previewDish()).colorScheme(.light)
//
////            DishCard(urlImage: nil, dishName: "Calzone", dishIngredients: "Cream, onions, ham, olives, herbs, verylongingredientName", price: "$10", rest: RestaurantFB.previewRest(), dish: DishFB.previewDish()).colorScheme(.dark)
//        }
//    }
//}
