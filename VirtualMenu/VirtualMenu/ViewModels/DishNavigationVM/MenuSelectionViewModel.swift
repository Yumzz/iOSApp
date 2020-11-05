//
//  MenuSelectionViewModel.swift
//  VirtualMenu
//
//  Created by William Bai on 9/3/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

class MenuSelectionViewModel: ObservableObject {
    let db = Firestore.firestore()
    var restaurant: RestaurantFB
    @Published var featuredDishes = [DishFB]()
    @Published var reviews = [RestaurantReviewFB]()
    
    init(restaurant: RestaurantFB) {
        self.restaurant = restaurant
        fetchFeaturedDishes()
        fetchReviews()
    }
    
    func fetchFeaturedDishes() {
        let featuredDishRefs = self.restaurant.featuredDishRefs
        for dishRef in featuredDishRefs {
            dishRef!.getDocument { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    let dish = DishFB.init(snapshot: snapshot!) ?? nil
                    if dish != nil {
                        self.featuredDishes.append(dish!)
                    }
                    else{
                        print("no featured dishes")
                    }
                }
            }
        }
    }
    
    func fetchReviews() {
        let reviewRefs = self.restaurant.reviews
        for reviewRef in reviewRefs {
            reviewRef!.getDocument{ (snapshot, error) in
                if let error = error {
                    print("Error getting reviews: \(error)")
                } else {
                    let review = RestaurantReviewFB.init(snapshot: snapshot!) ?? nil
                    if review != nil {
                        self.reviews.append(review!)
                    }
                    else{
                        print("no reviews")
                    }
                }
            }
        }
    }
    
    func publishReview(rating: Int64, text: String, user: UserProfile) {
        let newReviewRef = db.collection("RestaurantReview").document()
        newReviewRef.setData([
            "Rating": rating,
            "Text": text,
            "Restaurant": self.restaurant.ref!,
            "User": NSNull(),
            "Date": Timestamp(date: Date())
        ]) { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("Document successfully written!")
            }
        }
        db.collection("Restaurant").document(self.restaurant.key).updateData([
            "RatingSum": FieldValue.increment(Int64(rating)),
            "N_Ratings": FieldValue.increment(Int64(1)),
            "Reviews": FieldValue.arrayUnion([newReviewRef])
        ]) { err in
            if let err = err {
                print(err.localizedDescription)
            } else {
                print("Document successfully written2!")
            }
        }
        self.restaurant.ratingSum += rating
        self.restaurant.n_Ratings += 1
        self.restaurant.reviews.append(newReviewRef)
    }
    
}
