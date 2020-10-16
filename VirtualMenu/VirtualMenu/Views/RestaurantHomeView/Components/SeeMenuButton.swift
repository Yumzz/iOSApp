//
//  SeeMenuButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 10/15/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct SeeMenuButton: View {
    
    var body: some View {
//        Group {
            HStack{
                Image(systemName: "list.bullet.rectangle")
                    .font(.system(size: 18))
//                Spacer()
                Text("See the Menu")
                    .font(.system(size: 16, weight: .semibold))
                    .font(.footnote)
                    .frame(width: 150)
//                Spacer()
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
            .cornerRadius(10)
            .frame(width: 335, height: 50)

           
//        }
//        .background(ColorManager.yumzzOrange)
    }
}
