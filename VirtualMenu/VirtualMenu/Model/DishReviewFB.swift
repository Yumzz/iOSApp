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
    let userID: String
    let body: String
    let restaurant: String
    let dish: String
    let rating: Int
    var userPhoto: UIImage?
    var username: String

    
    init(headline: String, body: String, dish: String, restaurant: String, user: String, rating: Int, username: String, photo: UIImage) {
        //used when creating a review bc all info is available
        self.body = body
        self.dish = dish
        self.headline = headline
        self.restaurant = restaurant
        self.userID = user
        self.rating = rating
        self.userPhoto = photo
        self.username = username
    }
    
    init?(snapshot: QueryDocumentSnapshot){
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
            let dish = snapshot.data()["dishID"] as? String else {
            print("no name")
            return nil
        }
        guard
            let restaurant = snapshot.data()["restId"] as? String else {
            print("no name")
            return nil
        }
        
        guard
            let strRating = snapshot.data()["StarRating"] as? Int else {
            print("no name")
            return nil
        }
        guard
            let user = snapshot.data()["userid"] as? String else {
            print("no name")
            return nil
        }
        guard
            let name = snapshot.data()["username"] as? String else {
            print("no name")
            return nil
        }
        print("head: \(headline)")
        print("dish: \(dish)")
        print("rest: \(restaurant)")
        print("rating: \(strRating)")

        self.headline = headline
        self.dish = dish
        self.restaurant = restaurant
        self.body = body
        self.rating = strRating
        self.userID = user
        self.userPhoto = nil
        self.username = name
    }
    
}

extension DishReviewFB: Hashable {
static func == (lhs: DishReviewFB, rhs: DishReviewFB) -> Bool {
    return lhs.id == rhs.id
}
}
