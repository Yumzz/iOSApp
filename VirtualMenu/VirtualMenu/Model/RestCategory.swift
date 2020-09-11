//
//  RestCategory.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/10/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

struct RestCategory: Hashable {
    
    var isExpanded: Bool
    let restaurants: [RestaurantFB]
    let name: String
    
    init(isExpanded: Bool, restaurants: [RestaurantFB], name: String) {
        self.isExpanded = isExpanded
        self.restaurants = restaurants
        self.name = name
    }
}
