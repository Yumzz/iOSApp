//
//  HomeScreenViewModel.swift
//  VirtualMenu
//
//  Created by William Bai on 10/6/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

class HomeScreenViewModel: ObservableObject {
    let db = Firestore.firestore()
    let dispatchGroup = DispatchGroup()
    @Published var allRestaurants: [RestaurantFB] = [RestaurantFB]()
    
    init() {
        self.dispatchGroup.enter()
        fetchRestaurantsFB()
        self.dispatchGroup.notify(queue: .main) {

            self.allRestaurants.sort {
                $0.name < $1.name
            }
        }
    }
    
    func fetchRestaurantsFB(){
        db.collection("Restaurant").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    DispatchQueue.main.async {
                        let restaurant = RestaurantFB(snapshot: document)!
                        self.allRestaurants.append(restaurant)
                    }
                    if(document == snapshot!.documents.last){
                        self.dispatchGroup.leave()
                    }
                }
            }
        }
    }

}
