//
//  RestaurantSearchListViewModel.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 06/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

class RestaurantSearchListViewModel: ObservableObject {
    
    let db = Firestore.firestore()

    var restCategories: [RestCategory] = []
    
    let dispatchGroup = DispatchGroup()
    
    @Published var allRests: [RestaurantFB] = [RestaurantFB]()
    
    init() {
        
        self.dispatchGroup.enter()
                
        fetchRestaurantsFB()
                
        self.dispatchGroup.notify(queue: .main) {

            self.allRests.sort {
                $0.name < $1.name
            }
            print("sorting")

            self.categorizeRests(rests: self.allRests)
            
            print("catted")
            
            self.restCategories.sort {
                $0.name < $1.name
            }
                        
        }
        
        
    }
    
    func categorizeRests(rests: [RestaurantFB]) {
        var typeToRests = Dictionary<String, [RestaurantFB]>()
        
        for rest in rests {
            if typeToRests[rest.ethnicity] == nil {
                typeToRests[rest.ethnicity] = [rest]
            } else {
                typeToRests[rest.ethnicity]?.append(rest)
            }
        }
        
        for (category, rests) in typeToRests {
            restCategories.append(RestCategory(isExpanded: true, restaurants: rests, name: category))
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
                        self.allRests.append(restaurant)
                    }
                    if(document == snapshot!.documents.last){
                        print("hehehe")
                        self.dispatchGroup.leave()
                    }
                }
            }
        }
    }
    
}
