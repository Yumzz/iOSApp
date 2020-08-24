//
//  OrderCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/21/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct OrderCard: View {

    var urlImage:FBURLImage?

    var dish: DishFB
    
    @EnvironmentObject var order : Order
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    var body: some View{
        Group {
            VStack(alignment: .leading, spacing: 0){
                HStack(alignment: .top) {
                    Image("delete_cross")
                        .frame(width: 5, height: 5)
                        .onTapGesture {
                            self.order.deleteDish(dish: self.dish)
                    }
                }.position(x: UIScreen.main.bounds.width - 100, y: 20)
            HStack(alignment: .center, spacing: 20) {
                Spacer()
                    .frame(maxWidth: 0)
                if urlImage == nil {
                    Image(systemName: "circle.fill")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 88, height: 88, alignment: .leading)
                } else {
                    urlImage!
                        .frame(width: 100, height:100)
                        .clipShape(Circle())
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(dish.name).bold()
                        .foregroundColor(Color.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    

                    HStack (spacing: 5) {
                        Text("\(DishFB.formatPrice(price: dish.price))")
                            .foregroundColor(Color.secondary)
                            .font(.footnote)
                    }
                    
                }
                }
            }
            
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
            .background(Color.backgroundColor(for: colorScheme))
            .cornerRadius(10)
            //        .shadow(radius: 5)
        }
        .padding(.horizontal)
    }


}
