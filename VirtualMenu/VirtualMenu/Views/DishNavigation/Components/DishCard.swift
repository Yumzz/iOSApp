//
//  DishCard.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 31/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct DishCard: View {
    
    var urlImage:FBURLImage?
    
    var dishName: String
    var dishIngredients: String
    var price: String
    
    var rest: RestaurantFB
    
    var dish: DishFB
    
    let dispatchGroup = DispatchGroup()
    
//    @State private var alertMessage = ""
//    @State private var alertTitle = ""
    
    @EnvironmentObject var order : OrderModel
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    var body: some View {
        Group {
            HStack(alignment: .center, spacing: 20) {
                if urlImage == nil {
                    Image(systemName: "square.fill")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 88, height: 88, alignment: .leading)
                }
                else {
                    urlImage!
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                Spacer()
                    .frame(maxWidth: 0)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(dishName).bold()
                        .foregroundColor(Color.primary)

                    Text(price)
                        .foregroundColor(Color(UIColor().colorFromHex("#C4C4C4", 1)))
                        .font(.system(size: 10))
                }
                
                Spacer()
                
                Image("add_order")
                    .onTapGesture {
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
//                            print("\(self.order.dishRestaurant[self.dish])")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Alert"), object: nil)
                        }
                    }
                
                Spacer().frame(width: 5, height: 0)
                
//                Button
                
//                VStack(alignment: .leading, spacing: 10) {
//                    Text(dishName).bold()
//                        .foregroundColor(Color.primary)
//
//                    Text(price)
//                        .foregroundColor(Color.secondary)
//                }.frame(height: 70)
//                .padding(.leading, 5)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 70)
            .background(Color(.white))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
    }
}

struct DishCard_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            DishCard(urlImage: nil, dishName: "Tomato Pasta", dishIngredients: "Pasta, Tomato Sauce", price: "$10", rest: RestaurantFB.previewRest(), dish: DishFB.previewDish()).colorScheme(.light)
            
            DishCard(urlImage: nil, dishName: "Calzone", dishIngredients: "Cream, onions, ham, olives, herbs, verylongingredientName", price: "$10", rest: RestaurantFB.previewRest(), dish: DishFB.previewDish()).colorScheme(.dark)
        }
    }
}
