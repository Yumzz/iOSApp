//
//  OrderCard2.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 29/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct OrderCard2: View {
    
    var tax: Double
    var total: Double
    @State var isFavorite: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                Spacer()
                
                Image(systemName: "rectangle.fill")
                    .resizable()
                    .frame(width: 96, height: 96)
                
                Spacer()
                
                Button(action: {
                    self.isFavorite.toggle()
                }){
                    if !isFavorite {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.red)
                    } else {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.red)
                    }
                }
                
            }
            .padding(.top)
            .padding(.horizontal)
            
            
            HStack {
                Text("Edamame")
                    .foregroundColor(Color.secondary)
                
                Spacer()
                
                Text("$ 6.50")
                    .foregroundColor(Color.secondary)
            }
            .padding(.top)
            .padding(.horizontal, 32)
            
            Spacer()
                .frame(height: 60)
            
            HStack {
                Text("Subtotal")
                
                Spacer()
                
                Text("$ 14.50")
            }
            .padding(.horizontal, 32)
            
            HStack {
                Text("Tax")
                
                Spacer()
                
                Text("$ 0.00")
            }
            .padding(.horizontal, 32)
            
            Divider()
                .background(Color.primary)
                .padding(.horizontal)
            
            HStack {
                Text("Total")
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("$ 14.50")
                    .fontWeight(.bold)
            }
            .padding(.bottom)
            .padding(.horizontal, 32)
            
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .padding()
        .shadow(radius: 6)
    }
}

struct OrderCard_Previews: PreviewProvider {
    static var previews: some View {
        OrderCard2(tax: 0, total: 14.50 )
    }
}

