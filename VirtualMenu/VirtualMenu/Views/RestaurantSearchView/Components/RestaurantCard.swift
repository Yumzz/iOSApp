//
//  DishCard.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 31/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI


extension Color {
    static let light = Color(UIColor.secondarySystemBackground)
    static let dark = Color(UIColor.tertiarySystemBackground)
    
    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark {
            return dark
        } else {
            return light
        }
    }
}


struct RestaurantCard: View {
    
    var urlImage:FBURLImage?
    
    var restaurantName: String
    var restaurantAddress: String
    
    var ratingSum: Int64
    var nbOfRatings: Int64
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    
    var body: some View {
        Group {
            HStack(alignment: .center, spacing: 20) {
                Spacer()
                    .frame(maxWidth: 0)
                if urlImage != nil {
                    urlImage!
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
                    
                    HStack{
                        if self.nbOfRatings > 0 {
                            StarRatingView(rating: .constant(Int(Float(self.ratingSum) / Float(self.nbOfRatings))), fontSize: 12)
                            Text(String(Float(self.ratingSum) / Float(self.nbOfRatings)))
                                .foregroundColor(Color.secondary)
                                .font(.footnote)
                            Text("(" + String(self.nbOfRatings) + " ratings)")
                                .foregroundColor(Color.secondary)
                                .font(.footnote)
                        } else {
                            Text("No Ratings Yet")
                                .foregroundColor(Color.secondary)
                                .font(.footnote)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
            .background(Color.backgroundColor(for: colorScheme))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

struct RestaurantCard_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            RestaurantCard(urlImage: nil, restaurantName: "Oishii Bowl", restaurantAddress: "113 Dryden Rd, Ithaca", ratingSum: 560, nbOfRatings: 120).colorScheme(.light)
            
            RestaurantCard(urlImage: nil, restaurantName: "Oishii Bowl", restaurantAddress: "113 Dryden Rd, Ithaca", ratingSum: 580, nbOfRatings: 120).colorScheme(.dark)
        }
    }
}
