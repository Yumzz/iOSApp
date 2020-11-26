//
//  CoralButton.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import Foundation
import SwiftUI

struct BlackButton: View {
    
    var strLabel: String
    var imgName: String?
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                
                if (imageExists(named: imgName)){
                    
                    Image(imgName!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                
                Text(strLabel)
                           .foregroundColor(Color(UIColor().colorFromHex("#FFFFFF", 1)))
                               
            }
            .padding()
                
        .modifier(LeadingTextModifier(imgExists: imageExists(named: imgName)))
           
        }
        .cornerRadius(10)
        .background((Color.black))
    }
}
