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
                Spacer()
                    .frame(maxWidth: 0)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(restaurantName).bold()
                        .foregroundColor(Color.primary)
                    
                    
                    HStack (alignment: .center , spacing: 5) {
                        if self.nbOfRatings > 0 {
//                            StarRatingView(rating: .constant(Int(Float(self.ratingSum) / Float(self.nbOfRatings))), fontSize: 12)
                          
                            Image(systemName: "star.fill")
                                .font(.system(size: 12))
                                .foregroundColor(Color.pink)
                            VStack (alignment: .leading , spacing: 5) {
                                Text(String(format: "%.2f", Double(self.ratingSum) / Double(self.nbOfRatings)))
                                    .foregroundColor(Color.secondary)
                                    .font(.footnote)
                            }
                            VStack (alignment: .trailing , spacing: 5) {
                                Text("(" + String(self.nbOfRatings) + " ratings)")
                                    .foregroundColor(Color.secondary)
                                    .font(.footnote)
                            }
                        } else {
                            Text("No Ratings Yet")
                                .foregroundColor(Color.secondary)
                                .font(.footnote)
                        }
                        
                        Text(restaurantAddress)
                            .foregroundColor(Color.secondary)
                            .font(.footnote)
                    }
                }.padding(.leading, 5)
            }

            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 70)
            .background(Color(.white))
            .cornerRadius(10)
            .shadow(radius: 2)
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
