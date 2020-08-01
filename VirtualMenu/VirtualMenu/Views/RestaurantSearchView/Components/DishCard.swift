//
//  DishCard.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 31/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct DishCard: View {
    
    var image:Image?
    
    var restaurantName: String
    var restaurantAddress: String
    
    var score: Float
    var nbOfRatings: Int
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 20) {
            Spacer()
                .frame(maxWidth: 0)
            if image == nil {
                Image(systemName: "square.fill")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 88, height: 88, alignment: .leading)
            } else {
                image!
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 88, height: 88, alignment: .leading)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(restaurantName).bold()
                    .foregroundColor(Color.primary)
                
                Spacer()
                    .frame(maxHeight: 0)
                
                
                HStack (spacing: 5) {
                    
                    Text(restaurantAddress)
                        .foregroundColor(Color.secondary)
                        .font(.footnote)
                }
                
                HStack (spacing: 5) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    
                    Text(String(score)).bold()
                        .foregroundColor(Color.primary)
                        .font(.footnote)
                    
                    Text("(\(String(nbOfRatings)) Ratings)")
                        .foregroundColor(Color(UIColor.systemGray))
                        .font(.footnote)
                }
            }
        }
        .frame(width: 350, height: 120, alignment: .leading)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        
        
    }
}

struct DishCard_Previews: PreviewProvider {
    static var previews: some View {
        
        DishCard(image: nil, restaurantName: "Oishii Bowl", restaurantAddress: "113 Dryden Rd, Ithaca", score: 4.9, nbOfRatings: 120)
    }
}
