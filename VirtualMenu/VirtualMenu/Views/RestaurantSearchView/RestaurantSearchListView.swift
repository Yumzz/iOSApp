//
//  RestaurantSearchListView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 16/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct RestaurantSearchListView: View {
    var body: some View {
        List {
            restaurantSearchLabel()
        }
    }
}

struct RestaurantSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantSearchListView()
    }
}
