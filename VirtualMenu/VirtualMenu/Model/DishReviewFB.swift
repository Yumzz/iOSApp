//
//  DishReviewFB.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 8/6/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import Firebase

struct DishReviewFB{
    let headline: String
    let id = UUID()
    let user: UserProfile
    let body: String
    let restaurant: String
    let dish: String
    let rating: Int
    
    init(headline: String, body: String, dish: String, restaurant: String, user: UserProfile, rating: Int) {
        //used when creating a review bc all info is available
        self.body = body
        self.dish = dish
        self.headline = headline
        self.restaurant = restaurant
        self.user = user
        self.rating = rating
    }
    
    init?(snapshot: QueryDocumentSnapshot, user: UserProfile){
        //used when fetching from Firebase to add to DishFB list
        guard
            let headline = snapshot.data()["Headline"] as? String else {
            print("no name")
            return nil
        }
        guard
            let body = snapshot.data()["Body"] as? String else {
            print("no name")
            return nil
        }
        guard
            let dish = snapshot.data()["Dish"] as? String else {
            print("no name")
            return nil
        }
        guard
            let restaurant = snapshot.data()["Restaurant"] as? String else {
            print("no name")
            return nil
        }
        
        guard
            let strRating = snapshot.data()["StarRating"] as? Int else {
            print("no name")
            return nil
        }
        print("head: \(headline)")
        print("dish: \(dish)")
        print("rest: \(restaurant)")
        print("rating: \(strRating)")
        print("user: \(user.fullName)")

        self.headline = headline
        self.dish = dish
        self.restaurant = restaurant
        self.body = body
        self.rating = strRating
        self.user = user
        
        
        
    }
    
    
    
    
    
    
    
    
}
