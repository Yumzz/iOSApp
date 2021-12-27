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
                Image(systemName: "list.bullet")
                    .font(.system(size: 16))
                Spacer().frame(width: 5)
                Text("See the Menu")
                    .font(.system(size: 16, weight: .semibold))
                    .font(.footnote)
//                    .frame(width: 150)
//                Spacer()
            }
            .padding()
            .foregroundColor(Color.white)
            .cornerRadius(40)
            .frame(width: (19 * UIScreen.main.bounds.width)/20, height: 35)
            .background(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))

           
//        }
//        .background(ColorManager.yumzzOrange)
    }
}
