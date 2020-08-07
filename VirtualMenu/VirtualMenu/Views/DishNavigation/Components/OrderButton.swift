//
//  OrderButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/5/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct OrderButton: View {
    var buttonText: String = "Add to Order"
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5)
            .frame(width: 150, height: 55)
            .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                .padding(.top, 0)
            Text(buttonText)
        }

    }
}
