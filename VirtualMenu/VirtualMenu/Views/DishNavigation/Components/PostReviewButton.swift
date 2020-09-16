//
//  PostReviewButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/18/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct PostReviewButton: View {
    var buttonText: String = "Submit"
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5)
            .frame(width: 100, height: 30)
                .foregroundColor(Color(UIColor().colorFromHex("#F9958D", 1)))
                .padding(.top, 0)
            Text(buttonText)
                .foregroundColor(.white)
        }

    }
}
