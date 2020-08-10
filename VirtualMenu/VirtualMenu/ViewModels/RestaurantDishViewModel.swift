//
//  RestauarantDishViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on .
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import CloudKit
import Firebase
import MapKit

class RestaurantDishViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    let Eradius = 6371000
    
    let proximity = 30
    
    @Published var restDishes = [DishFB]()
    
    @Published var rest: RestaurantFB? = nil
    
    @Published var allRests: [RestaurantFB] = [RestaurantFB]()
    
    @Published var dishReviewsNoPhoto: [DishReviewFB] = [DishReviewFB]()
    @Published var dishReviewsWithPhoto: [DishReviewFB] = [DishReviewFB]()

    
    var images: [String:UIImage] = [String:UIImage]()
    
    var sectionItems: [DishCategory] = [DishCategory]()
    
    let dispatchGroup = DispatchGroup()
    let dispatchGroup1 = DispatchGroup()
    let dispatchGroup2 = DispatchGroup()
    
    let locationManager = LocationManager()
            
    //function to get nearby restaurants but no dish info
    //Average Price = low, medium, or high
    func fetchRestaurantsBasicInfo(){
            db.collection("Restaurant").getDocuments { (snapshot, error) in
            if let error = error {
                   print("Error getting documents: \(error)")
               } else {
                   for document in snapshot!.documents {
    //                   print("\(document.documentID) => \(document.data())")
    //                print(document.get("Name") as! String)
                    if(self.checkInRadius(coordinate: document.get("location") as! GeoPoint)){
                        DispatchQueue.main.async {
                            self.allRests.append(RestaurantFB(snapshot: document, dishes: self.restDishes)!)
                        }
                    }
                   }
                }
            }
        }
    
    func fetchRestaurantsFB(){
        db.collection("Restaurant").getDocuments { (snapshot, error) in
        if let error = error {
               print("Error getting documents: \(error)")
           } else {
               for document in snapshot!.documents {
//                   print("\(document.documentID) => \(document.data())")
//                print(document.get("Name") as! String)
                if(self.checkInRadius(coordinate: document.get("location") as! GeoPoint)){
                    DispatchQueue.main.async {
                        self.fetchRestsDishesFB(name: document.get("Name") as! String)
                        self.dispatchGroup.notify(queue: .main) {
                            let plates = self.restDishes
                            self.allRests.append(RestaurantFB(snapshot: document, dishes: plates)!)
                        }
                    }
                }
               }
            }
        }
    }
    
    
    func fetchSingleRestaurantFB(name: String){
            db.collection("Restaurant").getDocuments { (rests, error) in
            if let error = error {
                   print("Error getting documents: \(error)")
               } else {
                   for document in rests!.documents {
                       print("\(document.documentID) => \(document.data())")
                    if(document.get("Name") as! String == name){
                        self.rest = (RestaurantFB(snapshot: document)!)
                       }
                   }
                }
            }
    }
    
    func fetchRestsDishesFB(name: String){
        self.dispatchGroup.enter()
        let fb = Firestore.firestore()
        
        let ref = fb.collection("Dish")
        
        let query = ref.whereField("Restaurant", isEqualTo: name)
        
        var dishes: [DishFB] = []
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
    //                  print("\(document.documentID) => \(document.data())")
                    let dish = (document.get("Name") as! String)
                    self.getDishPhoto(dishName: dish, restName: name)
                    self.dispatchGroup1.notify(queue: .main) {
                        dishes.append(DishFB(snapshot: document, photo: self.images[dish]!)!)
                        //this returns nil sometimes - check it out
                        if(document == snapshot!.documents.last){
                            print("last")
                            self.images.removeAll()
                            self.restDishes = dishes
                            self.dispatchGroup.leave()
                        }
                    }
                }
            }
        }
    }
    
//    func getUserRatings(userId: String){
//        let fb = Firestore.firestore()
//
//        let ref = fb.collection("DishReview")
//
//        let query = ref.whereField("userId", isEqualTo: userId)
//
//        query.getDocuments { (snap, error) in
//
//        if let error = error {
//                   print("Error getting documents: \(error)")
//               } else {
//                   for document in snap!.documents {
//                    self.userRatings["users"] = document.data()
//                    //have this be global for ratings type to that [types ratings dict]
//            }
//            }
//        }
//    }
        
    
    func fetchDishReviewsFB(dishID: String, restId: String){
        dispatchGroup2.enter()
        let fb = Firestore.firestore()
        
        let ref = fb.collection("DishReview")
        
        let query = ref.whereField("dishID", isEqualTo: dishID)
                       .whereField("restId", isEqualTo: restId)
                
        query.getDocuments { (snapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            for document in snapshot!.documents {
                //going through each review of this dish in this restaurant
                //create and get userprofile from getUserOfReview
                //create DishReviewFB and append to dishReviews
//                self.getUserOfReview(username: (document.get("Username") as! String), id: (document.get("userid") as! String))
                print("username \(document.get("username"))")
                let review = DishReviewFB(snapshot: document)!
                self.dishReviewsNoPhoto.append(review)
            }
        }
        }

    }
    
    func fillReviewInfo(){
        for review in self.dishReviewsNoPhoto {
            print("userID: \(review.userID)")
            self.dishReviewsWithPhoto.append(DishReviewFB(headline: review.headline, body: review.body, dish: review.dish, restaurant: review.restaurant, user: review.userID, rating: review.rating, username: review.username, photo: self.getUserOfReviewsPhoto(userID: review.userID)))
        }
        dispatchGroup2.leave()
    }
    
    
    func getUserOfReviewsPhoto(userID: String) -> UIImage{
        //go through dishReviews
        //get photo of each person with id
        print("getting photo")
        print(userID)
        return Utils().loadUserProfilePhoto(userId: userID)!
    }
    
    
    
//    func getUserOfReview(username: String, id: String){
//        dispatchGroup2.enter()
//        let fb = Firestore.firestore()
//
//        let reference = fb.collection("User")
//
//        print(username)
//        print(id)
//
//        let query = reference.whereField("id", isEqualTo: id).whereField("username", isEqualTo: username)
//
//        //this query does not do anything
//
//        print("before gettin user: \(query.description)")
//
//        //build user profile from info here
//        query.getDocuments { (snap, error) in
//            if let error = error {
//                print("Error getting user: \(error)")
//            }else{
//                print("wow user exists")
//                for document in snap!.documents{
//
//                    self.profiles[(document.get("username") as! String)] = UserProfile(userId: (document.get("id") as! String), fullName: (document.get("username") as! String), emailAddress: (document.get("email") as! String), profilePicture: "", profPhoto: (Utils().loadUserProfilePhoto(userId: (document.get("id") as! String))))
//                }
//            }
//        }
//        dispatchGroup2.leave()
//    }
    
    
    
    func getDishPhoto(dishName: String, restName: String){
        self.dispatchGroup1.enter()

         var image: UIImage?
         //need current restaurant
         var storage = Storage.storage()
         var dName = dishName
         dName = dName.replacingOccurrences(of: " ", with: "-")
         dName = dName.lowercased()
         
 //        print("name: \(n)")
         
         let imagesRef = storage.reference().child("Restaurant/\(restName.lowercased())/dish/\(dName)/photo/Picture.jpg")
         imagesRef.getData(maxSize: 2 * 2048 * 2048) { data, error in
         if let error = error {
             print(error.localizedDescription)
         } else {
           // Data for "virtual-menu-profilephotos/\(name).jpg" is returned
             if(data == nil){
                 print("Name of dish without photo in FB: \(dName)")
             }
             image = UIImage(data: data!)!
            self.images[dishName] = image!
//            self.images.append(image!)
//            print(self.images)
            self.dispatchGroup1.leave()
            }
         }
     }

    func getDishAveragePrice(dishes: [DishFB]) -> Double{
        //make one for each category 
        var count = 0.0
        var averagePrice = 0.0
        
        for d in dishes {
            count = count + 1
            averagePrice = averagePrice + d.price
            
        }
        
        return averagePrice/count
        
    }
    
    func categorizeDishes(dishes: [DishFB]) {
        var typeToDishes: [String : [DishFB]] = [:]
        for dish in dishes {
            if (typeToDishes[dish.type] == nil) {
                typeToDishes[dish.type] = [dish]
            } else {
                typeToDishes[dish.type]?.append(dish)
            }
        }
        for (category, dishes) in typeToDishes {
            self.sectionItems.append(DishCategory(isExpanded: true, dishes: dishes, name: category))
        }
    }
    
    func formatPrice(price: Double) -> String {
        var x =  "$" + (price.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.2f", price) : String(price))
        if(x.numOfNums() < 3){
            x = x + "0"
        }
        return x
    }
    
    
    func getDistFromUser(coordinate: GeoPoint) -> Double{
        //haversine formula - distance in miles
//        const R = 6371e3; // metres
//        const φ1 = lat1 * Math.PI/180; // φ, λ in radians
//        const φ2 = lat2 * Math.PI/180;
//        const Δφ = (lat2-lat1) * Math.PI/180;
//        const Δλ = (lon2-lon1) * Math.PI/180;
//
//        const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
//                  Math.cos(φ1) * Math.cos(φ2) *
//                  Math.sin(Δλ/2) * Math.sin(Δλ/2);
//        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
//
//        const d = R * c; in meters
        //d = d x 0.00062137 in miles
        
        let lat1 = coordinate.latitude * Double.pi/180
        let lat2 = locationManager.location!.coordinate.latitude * Double.pi/180
        
        let long1 = coordinate.longitude
        let long2 = locationManager.location!.coordinate.longitude
        
        let deltaLat = (lat2 - lat1) * Double.pi/180
        let deltaLong = (long2 - long1) * Double.pi/180
        
        let a = sin(deltaLat/2) * sin(deltaLat/2) + cos(long1) * cos(long2) * sin(deltaLong/2) * sin(deltaLong/2)
        
        
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        let d = Double(Eradius) * c
        
        return Double(d * 0.00062137)
        
        
    }
    
    
    func checkInRadius(coordinate: GeoPoint) -> Bool{
        let dist = self.getDistFromUser(coordinate: coordinate)
        if(dist <= Double(proximity)){
            return true
        }
        else{
            return false
        }
        
        
    }
    
    
    
    
    
    

}
