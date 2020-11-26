//
//  BlackButton.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct WhiteButton: View {
    
    var strLabel: String
    
    var body: some View {
        Group {
            Text(strLabel)
            .foregroundColor(
                Color(
                    UIColor().colorFromHex("#000000", 1)
                )
            )
            .padding()
            .frame(width: UIScreen.main.bounds.width/1.5, height: 40)
        }
            .cornerRadius(10)
            .background(Color(UIColor().colorFromHex("#FFFFFF", 1)))
    }
}

struct WhiteButton_Previews: PreviewProvider {
    static var previews: some View {
        WhiteButton(strLabel: "BUTTON")
    }
}
