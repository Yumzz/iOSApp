//
//  Order.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

struct Order: Hashable {
    var dishes: [DishFB]
    var totalPrice: Double
    var rest: String
    var id: UUID = UUID()
    var time: Date = Date()
}

extension Order {
    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
