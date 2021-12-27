//
//  DishCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 31/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct DishCard: View {
    
//    #if !APPCLIP
//    var urlImage:FBURLImage?
//    #endif
    var dishName: String
    var dishIngredients: String
    var price: String
    var singPrice: Bool
    var rest: RestaurantFB
    
    var dish: DishFB
    var dark: Bool = false
    
    let dispatchGroup = DispatchGroup()
    
//    @State private var alertMessage = ""
//    @State private var alertTitle = ""
    
    
//    #if !APPCLIP
    @EnvironmentObject var order : OrderModel
//    #endif
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    var body: some View {
        Group {
            HStack(alignment: .center, spacing: 10) {
                
                Spacer()
                    .frame(width: 4)
                
                VStack(alignment: .leading, spacing: 10) {
//                    if dish.photoExists {
//                        Text(dishName + "- Tap for Pic").bold()
    //                        .foregroundColor(Color.primary)
//                            .foregroundColor(.black)
//                    }
//                    else{
                    HStack{
                        Text(dishName).bold()
//                            .foregroundColor(Color.primary)
                            .foregroundColor(dark ? .white : .black)
//                        TagCard(dish: dish, dark: dark)
                    }
                    
                    if(dish.description != ""){
                        Text(dishIngredients)
    //                        .foregroundColor(Color.secondary)
                            .foregroundColor(dark ? .white : .gray)
                            .font(.system(size: 14))
                    }
                    
                    if(String(dish.price).components(separatedBy: ".")[1].count < 2){
                        if(String(dish.price).components(separatedBy: ".")[1].count < 1){
                            Text(String(dish.price) + "00").font(.system(size: 12, weight: .semibold)).foregroundColor(dark ? ColorManager.darkModeOrange : Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
                            Spacer()
                        }
                        else{
                            Text(String(dish.price) + "0").font(.system(size: 12, weight: .semibold)).foregroundColor(dark ? .white : Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
                            Spacer()
                        }
                    }
                    else{
                        Text(String(dish.price)).font(.system(size: 12, weight: .semibold)).foregroundColor(dark ? .white : Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
                        Spacer()
                    }
//                    Text(price.numOfNums() < 4 ? (price.numOfNums() < 3 ? price + "00" : price + "0") : price)
//                        .foregroundColor(Color(UIColor().colorFromHex("#C4C4C4", 1)))
//                        .font(.system(size: 14))
                }
                
                Spacer()
                
//                #if !APPCLIP
//                if dish.photoExists{
//                    urlImage!
//                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                }
//
//                Spacer().frame(width: 8, height: 0)
//                #endif
                
//                #if !APPCLIP
                ZStack {
                    Rectangle()
                        .fill(dark ? ColorManager.darkModeOrange : Color("YumzzOrange"))
                        .frame(width: 20, height: 6)
                    
                    Rectangle()
                        .fill(dark ? ColorManager.darkModeOrange : Color("YumzzOrange"))
                        .frame(width: 6, height: 20)
                }
                .onTapGesture {
                        print("added haha")
                        if(!self.order.checkSameRest(dish: self.dish)){
//                            self.alertTitle = "Different Restaurant"
//                            self.alertMessage = "A new order has been started for \(self.rest.name)"
//                            self.showingAlert.toggle()
                            self.order.newOrder(rest: self.rest)
                        }else{
//                            self.order.
//                            self.alertTitle = "Dish Added"
//                            self.alertMessage = "A new dish has been added to your order. Check the order tab to see your entire order."
//                            self.showingAlert.toggle()
                        }
                        self.dispatchGroup.enter()
                        print("added to order haha")
                        self.order.restChosen = self.rest
                        self.order.addDish(dish: self.dish, rest: self.rest, dis: self.dispatchGroup)
                        //ask for side choice here
                        self.dispatchGroup.notify(queue: .main){
                            print("posted special instruction haha")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Special Instruction"), object: (dish, singPrice))
//                            NotificationCenter.default.post(name: Notification.Name(rawValue: "Alert"), object: singPrice)
//                            if !dish.choices.isEmpty{
//
//                            }
                        }
                    }
//                #endif
                
                Spacer().frame(width: 15, height: 0)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 112)
            .background(dark ? Color(.black) : Color(.white))
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
