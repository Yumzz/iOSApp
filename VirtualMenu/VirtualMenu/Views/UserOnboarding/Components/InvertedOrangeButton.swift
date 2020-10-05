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
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                                
                Text(strLabel)
                           .foregroundColor(Color(UIColor().colorFromHex("#E05C28", 1)))
                               
            }
            .padding()
            .frame(width: width, height: height)
            .cornerRadius(10)
           
        }
        
        .background(Color(UIColor().colorFromHex("#FFFFFF", 1)))
        .shadow(radius: 5)
//        .frame(width: width, height: height)
    }
}
