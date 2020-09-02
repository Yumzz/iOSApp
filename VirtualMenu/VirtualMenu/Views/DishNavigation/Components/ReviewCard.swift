//
//  ReviewCard.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/1/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct ReviewCard: View {

    var urlImage:FBURLImage?
    
    var review: String

    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    var body: some View {
        
        HStack(alignment: .top, spacing: 20) {
        
            if urlImage == nil {
                Image(systemName: "square.fill")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 88, height: 88, alignment: .leading)
            }
            else {
                urlImage!
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            
            VStack(alignment: .leading) {
                Text(review)
                    .foregroundColor(.primary)
                    .font(.headline)
            }
            
            
        }
        
    }

}
