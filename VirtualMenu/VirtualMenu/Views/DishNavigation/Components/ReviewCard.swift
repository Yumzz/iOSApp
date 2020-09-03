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
        
        HStack(alignment: .center, spacing: 40) {
        
            if urlImage == nil {
                Image(uiImage: UIImage(imageLiteralResourceName: "profile_photo_edit"))
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50, alignment: .leading)
            }
            else {
                urlImage!
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50, alignment: .leading)
            }
            
            VStack(alignment: .leading) {
                Text(review)
                    .foregroundColor(.primary)
                    .font(.headline)
            }
            
            
        }
        
    }

}
