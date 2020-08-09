//
//  RestaurantSearchListViewModel.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 06/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

class RestaurantSearchListViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var allRests: [RestaurantFB] = [RestaurantFB]()
    
    init() {
        fetchRestaurantsFB()
    }
    
    func fetchRestaurantsFB(){
        db.collection("Restaurant").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in snapshot!.documents {
                    DispatchQueue.main.async {
                        let restaurant = RestaurantFB(snapshot: document, dishes: [], averagePrice: .zero)!
                        self.allRests.append(restaurant)
                    }
                }
            }
        }
    }
    
}
