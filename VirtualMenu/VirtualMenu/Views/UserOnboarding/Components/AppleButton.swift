//
//  AppleButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/5/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct AppleButton: View {
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                
                Image("Apple")
                                
                Text("Continue with Apple")
                           .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                               
            }
            .padding()
            .frame(width: width, height: height)

           
        }
        .background((Color(UIColor().colorFromHex("#000000", 1))))
    }
}

