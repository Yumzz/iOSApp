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
    var restaurant: DocumentReference? = nil
    var userID: String = ""
    let text: String
    let date: Date
    
    init?(snapshot: DocumentSnapshot) {
        guard let rating = snapshot.data()?["Rating"] as? Int else {
            print("no rating")
            return nil
        }
        guard let text = snapshot.data()?["Text"] as? String else {
            print("no text")
            return nil
        }
//        guard let date = snapshot.data()?["Date"] as? Date else {
//            print("no date")
//            return nil
//        }
        
        self.rating = rating
        self.text = text
        self.date = Date()
        //self.date = date
        
        if (snapshot.get("UserID") != nil) {
            if let user = snapshot.data()?["UserID"] as? String {
                self.userID = user
            }
        }
        if (snapshot.get("Restaurant") != nil) {
            if let restaurant = snapshot.data()?["Restaurant"] as? DocumentReference {
                self.restaurant = restaurant
            }
        }
        
    }
}
