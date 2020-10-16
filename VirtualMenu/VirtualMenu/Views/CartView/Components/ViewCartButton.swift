//
//  ViewCartButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/15/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct ViewCartButton: View {
    var dishCount: Int
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                Image("cart")
                    .frame(width: 18, height: 15)
                                
                Spacer()
                
                Text("View Cart")
                           .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                
                Spacer()
                
                Circle()
                    .frame(width: 18, height: 18)
                    .foregroundColor(Color(UIColor().colorFromHex("#D44F32", 1)))
                    .overlay(Text("\(dishCount)").foregroundColor(Color.white))
                    
                               
            }
            .padding()
            .frame(width: 335, height: 50)

           
        }
        .background(ColorManager.yumzzOrange)
    }
}
