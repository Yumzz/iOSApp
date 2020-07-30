//
//  SearchBarButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/29/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct SearchBarButton: View {
    
    var strLabel: String
    
    var body: some View {
        Group {
            Text(strLabel)
            .foregroundColor(
                Color(
                    UIColor().colorFromHex("#000000", 1)
                )
            )
            .frame(width: UIScreen.main.bounds.width/6, height: 40)
        }
            .cornerRadius(10)
            .background(Color(UIColor().colorFromHex("#FFFFFF", 1)))
    }
}

struct SearchBarButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarButton(strLabel: "BUTTON")
    }
}
