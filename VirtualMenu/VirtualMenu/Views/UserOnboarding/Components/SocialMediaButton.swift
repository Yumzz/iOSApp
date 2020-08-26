//
//  SocialMediaButton.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/26/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct SocialMediaButton: View {
    
    var imgName: String?
    
    var body: some View {
        Group {
            HStack(spacing: 10) {
                
                if (imageExists(named: imgName)){
                    
                    Image(imgName!)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 30)
//                    .cornerRadius(60)
                        .background(Color(UIColor(white: 1, alpha: 0)))
                }
                               
            }
            .padding()
                           
        }
        .cornerRadius(60)
        .background((Color.white))
        .shadow(radius: 4)
//        .shadow(radius: 10)
    }
}
