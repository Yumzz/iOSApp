//
//  OrangeButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/4/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct OrangeButton: View {
    
    var strLabel: String
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                                
                Text(strLabel)
                           .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                               
            }
            .padding()
            .frame(width: width, height: height)

           
        }
        .background(Color("YumzzOrange"))
    }
}
