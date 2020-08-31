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
            .frame(width: UIScreen.main.bounds.width/2, height: 40)
                .foregroundColor(Color(
                    UIColor().colorFromHex("#FFFFFF", 1)
                ))
                .padding(.top, 0)
            Text(buttonText)
            .foregroundColor(Color(UIColor().colorFromHex("#707070", 1)))
            } .shadow(radius: 5)

    }
}
