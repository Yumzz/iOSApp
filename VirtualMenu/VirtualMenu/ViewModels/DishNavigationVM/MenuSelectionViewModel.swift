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
    var reviewPhoto: UIImage?
    @Published var featuredDishes = [DishFB]()
    @Published var reviews = [RestaurantReviewFB]()
    
    init(restaurant: RestaurantFB) {
        self.restaurant = restaurant
        self.reviewPhoto = nil
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
            "UserID": Auth.auth().currentUser?.uid ?? "",
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
    
    func getPhoto(dispatch: DispatchGroup, id: String){
        let storage = Storage.storage()
        let imagesRef = storage.reference().child("profilephotos/\(id)")
        var im: UIImage? = nil
        DispatchQueue.global(qos: .background).async{
            imagesRef.getData(maxSize: 2 * 2048 * 2048) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
//                    im = UIImage(imageLiteralResourceName: "profile_photo_edit")
                    print(error.localizedDescription)
                    self.reviewPhoto = im
                    dispatch.leave()
                } else {
                    // Data for "profilephotos/\(uid).jpg" is returned
                    // print("data: \(data)")
                    print("made it here: \(id)")
                    self.reviewPhoto = im
                    dispatch.leave()
                }
                print("leave")
            }
        }
    }
    
    func loadName(userId: String) -> String{
        var name = ""
        Firestore.firestore().collection("User").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    if(document.get("uid") as! String == userId){
                        name = document.get("username") as! String
                        return
                    }
                }
            }
        }
        return name
    }
    
}
