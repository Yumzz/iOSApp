//
//  RestaurantSearchLabel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/17/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct restaurantSearchLabel: View {
    
    var restaurantName: String = "Restaurant"
    var restaurantAddress: String = "Address"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.restaurantName)
                .font(.headline)
            Text(self.restaurantAddress)
                .font(.caption)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        restaurantSearchLabel()
    }
}
