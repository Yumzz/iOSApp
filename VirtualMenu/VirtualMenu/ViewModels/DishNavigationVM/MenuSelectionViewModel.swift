//
//  MenuSelectionViewModel.swift
//  VirtualMenu
//
//  Created by William Bai on 9/3/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

class MenuSelectionViewModel: ObservableObject {
    let db = Firestore.firestore()
    var restaurant: RestaurantFB
    @State var reviewPhoto: UIImage?
    var reviewPhotos: [String: UIImage] = [String: UIImage]()

    @Published var featuredDishes = [DishFB]()
    @Published var reviews = [RestaurantReviewFB]()
    
    init(restaurant: RestaurantFB) {
        self.restaurant = restaurant
        self.reviewPhoto = nil
        fetchFeaturedDishes()
        fetchReviews()
        self.reviews.sort {
            $0.date < $1.date
        }
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
    
    #if !APPCLIP
    func publishReview(rating: Int64, text: String, user: UserProfile) {
        let newReviewRef = db.collection("RestaurantReview").document()
        newReviewRef.setData([
            "Rating": rating,
            "Text": text,
            "Restaurant": self.restaurant.ref!,
            "UserID": Auth.auth().currentUser?.uid ?? "",
            "Date": Timestamp(date: Date()),
            "Name": user.fullName
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
    #endif
    
    func getPhoto(dispatch: DispatchGroup, id: String){
        let storage = Storage.storage()
        let imagesRef = storage.reference().child("profilephotos/\(id)")
            imagesRef.getData(maxSize: 2 * 2048 * 2048) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
//                    im = UIImage(imageLiteralResourceName: "profile_photo_edit")
                    print("wowza: \(error.localizedDescription)")
                    self.reviewPhoto = nil
                    dispatch.leave()
                } else {
                    // Data for "profilephotos/\(uid).jpg" is returned
                    // print("data: \(data)")
                    print("made it here: \(id)")
                    self.reviewPhoto = UIImage(data: data!)
                    dispatch.leave()
                }
                print("leave")
        }
    }
    
    
    static func loadUserProfilePhoto(userId: String) -> UIImage? {
        print("loadcalled")
        var retImage: UIImage? = nil
        
        self.getUserProfileImgURL(userId: userId) { (profileImgURL) in
        if let url = URL(string: profileImgURL) {
            
            let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if(error != nil){
                    print(error?.localizedDescription ?? "error")
                    
                }
                
                guard let imageData = data else {
                    return
                }
                
                OperationQueue.main.addOperation {
                    guard let image = UIImage(data: imageData) else { print("no image")
                        return }
                    retImage = image
                    
                }
                
            })
            downloadTask.resume()
            }
//                  }
          }
        return retImage
      }
    
    static func getUserProfileImgURL(userId: String, completionHandler: @escaping (String) -> Void) {
            
            // Get the rest of the user data
//        DispatchQueue.main.async {
        Database.database().reference().child("User").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            if let userValues = snapshot.value as? NSDictionary {
                
//                if let userPhotoURL = userValues[] as? String {
//                    completionHandler(userPhotoURL)
//                }
            }
        })
//        }
    }
    
    
    
//    func getPhoto(dispatch: DispatchGroup, id: String) -> UIImage{
//        let storage = Storage.storage()
//        let imagesRef = storage.reference().child("profilephotos/\(id)")
//        var im: UIImage? = nil
//        DispatchQueue.global(qos: .background).async{
//            imagesRef.getData(maxSize: 2 * 2048 * 2048) { data, error in
//                if let error = error {
//                    // Uh-oh, an error occurred!
////                    im = UIImage(imageLiteralResourceName: "profile_photo_edit")
//                    print(error.localizedDescription)
//                    self.reviewPhoto = im
//                    dispatch.leave()
//                } else {
//                    // Data for "profilephotos/\(uid).jpg" is returned
//                    // print("data: \(data)")
//                    print("made it here: \(id)")
//                    self.reviewPhoto = im
//                    dispatch.leave()
//                }
//                print("leave")
//            }
//        }
//    }
    
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
