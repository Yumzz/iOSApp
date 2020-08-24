//
//  AddReviewButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/17/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct AddReviewButton: View {
    var buttonText: String = "Add Review"
    
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
