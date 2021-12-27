//
//  InvertedOrangeButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/4/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct InvertedOrangeButton: View {
    
    var strLabel: String
    var width: CGFloat
    var height: CGFloat
    var dark: Bool = false

    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                                
                Text(strLabel)
                    .foregroundColor(dark ? ColorManager.white : ColorManager.yumzzOrange)
                               
            }
            .padding()
            .frame(width: width, height: height)
            .cornerRadius(10)
           
        }
        
        .background(dark ? ColorManager.blackest : Color(UIColor().colorFromHex("#FFFFFF", 1)))
        .shadow(radius: 5)
//        .frame(width: width, height: height)
    }
}
