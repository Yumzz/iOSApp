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
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    var body: some View {
        Group {
            HStack(alignment: .top, spacing: 20) {
                Spacer()
                    .frame(maxWidth: 0)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(dishName).bold()
                        .foregroundColor(Color.primary)
                    
                    Spacer()
                        .frame(maxHeight: 0)
                    
                    Text(dishIngredients)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(2)
                        .foregroundColor(Color.secondary)
                        .font(.footnote)
                    
                    Text(price)
                        .foregroundColor(Color.primary)
                }
                
                Spacer()
                
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
                
                Spacer().frame(width: 0)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 160)
            .background(Color.backgroundColor(for: colorScheme))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .padding(.horizontal)
    }
}

struct DishCard_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            DishCard(urlImage: nil, dishName: "Tomato Pasta", dishIngredients: "Pasta, Tomato Sauce", price: "$10").colorScheme(.light)
            
            DishCard(urlImage: nil, dishName: "Calzone", dishIngredients: "Cream, onions, ham, olives, herbs, verylongingredientName", price: "$10").colorScheme(.dark)
        }
    }
}
