//
//  DishCategory.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/4/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//
import Foundation

struct DishCategory: Hashable {
    var isExpanded: Bool
    let dishes: [DishFB]
    let name: String
    var id: UUID
    var description: String
    
    init(isExpanded: Bool, dishes: [DishFB], name: String, description: String) {
        self.isExpanded = isExpanded
        self.dishes = dishes
        self.name = name
        self.id = UUID()
        self.description = description
    }
}
