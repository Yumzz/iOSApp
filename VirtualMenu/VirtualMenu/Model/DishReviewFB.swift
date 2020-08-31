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
    let id = UUID()
    let userID: String
    let body: String
    let restaurant: String
    let dish: String
    let rating: Int
    var userPhoto: UIImage?
    var username: String
    var userPhotoURL: String

    
    init(body: String, dish: String, restaurant: String, user: String, rating: Int, username: String, photo: UIImage) {
        //used when creating a review bc all info is available
        self.body = body
        self.dish = dish
        self.restaurant = restaurant
        self.userID = user
        self.rating = rating
        self.userPhoto = photo
        self.username = username
        self.userPhotoURL = "profilephotos/\(userID)"
    }
    
    init?(snapshot: QueryDocumentSnapshot){
        //used when fetching from Firebase to add to DishFB list
        guard
            let body = snapshot.data()["Body"] as? String else {
            print("no body")
            return nil
        }
        guard
            let dish = snapshot.data()["dishID"] as? String else {
            print("no dish")
            return nil
        }
        guard
            let restaurant = snapshot.data()["restID"] as? String else {
            print("no restaurant")
            return nil
        }
        
        guard
            let strRating = snapshot.data()["StarRating"] as? Int else {
            print("no star Rating")
            return nil
        }
        guard
            let user = snapshot.data()["userid"] as? String else {
            print("no user")
            return nil
        }
        guard
            let name = snapshot.data()["username"] as? String else {
            print("no name")
            return nil
        }
        print("dish: \(dish)")
        print("rest: \(restaurant)")
        print("rating: \(strRating)")

        self.dish = dish
        self.restaurant = restaurant
        self.body = body
        self.rating = strRating
        self.userPhoto = nil
        if(name == ""){
            print("no user")
            self.username = "Guest User"
            self.userID = ""
            self.userPhotoURL = ""
        }
        else{
            print("user")
            self.username = name
            self.userID = user
            self.userPhotoURL = "profilephotos/\(userID)"
        }
    }
    
}

extension DishReviewFB: Hashable {
static func == (lhs: DishReviewFB, rhs: DishReviewFB) -> Bool {
    return lhs.id == rhs.id
}
}
