//
//  FirebaseRequest.swift
//  VirtualMenu
//
//  Created by EageRAssassin on 6/30/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseRequest {

    let db = Firestore.firestore()
        
    init() {
        
    }
    
//    func fetchAllDishes() -> [DishFB] {
//        var dishList : [DishFB] = []
//
//        db.collectionGroup("Dish").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                    dishList.append(DishFB(snapshot: document)!)
//                }
//            }
//        }
//
//        return dishList
//    }
    
    func fetchUser() -> UserProfile{
        return user
    }
    
    ///fetchDish() will fetch the dish given id in the database
    ///- Parameters:
    ///     - id : the id of the dish
    ///- Returns: the Dish in the database
//    func fetchDish(recordID : String) -> Dish {
//
    //    let docRef = db.collection("cities").document("SF")
    //
    //    docRef.getDocument { (document, error) in
    //        if let document = document, document.exists {
    //            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
    //            print("Document data: \(dataDescription)")
    //        } else {
    //            print("Document does not exist")
    //        }
    //    }
//    }
}
