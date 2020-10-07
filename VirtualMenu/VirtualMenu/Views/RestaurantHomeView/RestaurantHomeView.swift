//
//  RestaurantHomeView.swift
//  VirtualMenu
//
//  Created by William Bai on 10/7/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct RestaurantHomeView: View {
    var restaurant: RestaurantFB
    
    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                .fill(Color(#colorLiteral(red: 0.7686274647712708, green: 0.7686274647712708, blue: 0.7686274647712708, alpha: 1)))

                FBURLImage(url: restaurant.coverPhotoURL, imageWidth: 375, imageHeight: 240)
                .clipped()
            }
            .frame(width: 375, height: 240)
        }
    }
}

struct RestaurantHomeView_Previews: PreviewProvider {
    static var previews: some View {
        //RestaurantHomeView()
        EmptyView()
    }
}
