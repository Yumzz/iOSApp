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
            .frame(width: 150, height: 55)
            .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                .padding(.top, 0)
            Text(buttonText)
                .foregroundColor(.white)
        }

    }
}
