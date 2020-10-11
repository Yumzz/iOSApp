//
//  FacebookButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/5/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct FacebookButton: View {
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                
                Image("Facebook")
                                
                Text("Continue with Facebook")
                           .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                               
            }
            .padding()
            .frame(width: width, height: height)

           
        }
        .background(ColorManager.facebookBlue)
    }
}
