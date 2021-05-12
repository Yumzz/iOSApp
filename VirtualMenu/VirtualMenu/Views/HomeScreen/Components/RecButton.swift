//
//  RecButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/10/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct RecButton: View {
    
    var body: some View {
        Group {
            HStack{
//                Image(systemName: "list.bullet.rectangle")
//                    .font(.system(size: 18))
//                Spacer()
                Text("Recommend Me")
                    .font(.system(size: 16, weight: .semibold))
                    .font(.footnote)
                    .frame(width: 150)
//                Spacer()
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
            .cornerRadius(10)
            .frame(width: 160, height: 35)

           
        }
//        .background(ColorManager.yumzzOrange)
    }
}
