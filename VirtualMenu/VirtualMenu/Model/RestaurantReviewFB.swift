//
//  RestaurantReviewFB.swift
//  VirtualMenu
//
//  Created by William Bai on 10/26/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import Firebase

struct RestaurantReviewFB{
    let id = UUID()
    let rating: Int
    let restaurant: DocumentReference?
    let user: DocumentReference?
    let text: String
    let date: Date
    
    
}
