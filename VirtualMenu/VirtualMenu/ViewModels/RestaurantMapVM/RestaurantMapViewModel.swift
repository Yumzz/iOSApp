//
//  RestaurantMapViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/10/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

class RestaurantMapViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var allRests: [RestaurantFB] = [RestaurantFB]()

    @Published var restDishes = [DishFB]()
    
    let locationManager = LocationManager()
    
    let Eradius = 6371000
    
    let proximity = 30

    
    func fetchRestaurantsBasicInfo(disp: DispatchGroup){
        disp.enter()
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
                    if(document == snapshot?.documents.last){
                        disp.leave()
                    }
                }
            }
        }
    }
    
    func getDistFromUser(coordinate: GeoPoint) -> Double {
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
    
    
    func checkInRadius(coordinate: GeoPoint) -> Bool {
        let dist = self.getDistFromUser(coordinate: coordinate)
        if(dist <= Double(proximity)){
            return true
        }
        else {
            return false
        }
    }
    
}
