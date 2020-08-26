//
//  GuestButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/26/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import Foundation
import SwiftUI

struct GuestButton: View {
    
    var strLabel: String
    
    var body: some View {
                
            Text(strLabel)
            .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
            .frame(width: UIScreen.main.bounds.width/1.5, height: 10)
            .padding()
            .cornerRadius(60)
            .background(Color(UIColor().colorFromHex("#707070", 1)))
    }
}
