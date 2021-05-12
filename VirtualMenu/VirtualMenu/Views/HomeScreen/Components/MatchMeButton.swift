//
//  MatchMeButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/10/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct MatchMeButton: View {
    
    var body: some View {
        Group {
            HStack{
//                Image(systemName: "list.bullet.rectangle")
//                    .font(.system(size: 18))
//                Spacer()
                Text("Match Me")
                    .font(.system(size: 16, weight: .semibold))
                    .font(.footnote)
                    .frame(width: 80)
//                Spacer()
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
            .cornerRadius(10)
            .frame(width: 90, height: 35)

           
        }
//        .background(ColorManager.yumzzOrange)
    }
}
