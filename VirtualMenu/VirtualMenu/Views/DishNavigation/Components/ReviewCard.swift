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
    
    var body: some View {
        
        Group{
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
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50, alignment: .leading)
                }
                                
                VStack(alignment: .leading) {
                    Text(review)
                        .foregroundColor(Color.black)
                        .font(.headline)
                }
                
            }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 70)
                    .background(Color(.white))
            
                    .cornerRadius(10)
                    .shadow(radius: 2)
        
        }
    }

}
