//
//  DishCard.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 31/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct DishPreviewCard: View {
    
    var urlImage:FBURLImage?
    
    var dishName: String
    var dishIngredients: String
    var price: String
    
    let dispatchGroup = DispatchGroup()
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @EnvironmentObject var order : OrderModel
        
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

struct DishPreviewCard_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            DishPreviewCard(urlImage: nil, dishName: "Tomato Pasta", dishIngredients: "Pasta, Tomato Sauce", price: "$10").colorScheme(.light)
            
            DishPreviewCard(urlImage: nil, dishName: "Calzone", dishIngredients: "Cream, onions, ham, olives, herbs, verylongingredientName", price: "$10").colorScheme(.dark)
        }
    }
}
