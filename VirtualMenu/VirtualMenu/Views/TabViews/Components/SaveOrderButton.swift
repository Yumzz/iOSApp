//
//  SaveOrderButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/1/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct SaveOrderButton: View {
    var buttonText: String = "Save Order"
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 5)
            .frame(width: 100, height: 30)
            .foregroundColor(Color(UIColor().colorFromHex("#F88379", 1)))
                .padding(.horizontal, 20)
            Text(buttonText)
                .foregroundColor(.white)
        }

    }
}
