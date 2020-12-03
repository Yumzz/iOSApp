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
    let builds: [BuildFB]
    let name: String
    var id: UUID
    var description: String
    
    init(isExpanded: Bool, dishes: [DishFB]? = nil, builds: [BuildFB]? = nil, name: String, description: String) {
        self.isExpanded = isExpanded
        if(dishes != nil){
            self.dishes = dishes!
        }
        else{
            self.dishes = []
        }
        if(builds != nil){
            self.builds = builds!
        }
        else{
            self.builds = []
        }
        self.name = name
        self.id = UUID()
        self.description = description
    }
}
