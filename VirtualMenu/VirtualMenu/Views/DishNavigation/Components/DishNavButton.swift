//
//  DishNavButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct DishNavButton: View {
    
    var strLabel: String
    
    var body: some View {
        Group {
            Text(strLabel)
            .foregroundColor(
                Color(
                    UIColor().colorFromHex("#707070", 1)
                )
            )
            .padding()
            .frame(width: UIScreen.main.bounds.width/2, height: 40)
        }
            .cornerRadius(10)
            .background(Color(UIColor().colorFromHex("#FFFFFF", 1)))
            .shadow(radius: 5)
    }
}
