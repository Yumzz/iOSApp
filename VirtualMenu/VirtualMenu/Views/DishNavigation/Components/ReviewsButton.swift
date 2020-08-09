//
//  ReviewsButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/6/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct ReviewsButton: View {
    var buttonText: String = "Reviews"
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5)
            .frame(width: 150, height: 55)
                .foregroundColor(.black)
                .padding(.top, 0)
            Text(buttonText)
            .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
        }

    }
}
