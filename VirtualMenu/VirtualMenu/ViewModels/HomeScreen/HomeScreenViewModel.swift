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
    
    var locationManager = LocationManager()
        
    let Eradius = 6371000
    
    let proximity = 30
    
    init(dispatch: DispatchGroup) {
        dispatch.enter()
        self.dispatchGroup.enter()
        fetchRestaurantsFB()
        self.dispatchGroup.notify(queue: .main) {

//            self.allRestaurants.sort {
//                $0.name < $1.name
//            }
            print("here at hsvm")
            self.allRestaurants.sort {
                (self.getDistFromUser(coordinate: $0.coordinate)) < (self.getDistFromUser(coordinate: $1.coordinate))
            }
            dispatch.leave()
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
//                        if(self.checkInRadius(coordinate: document.get("location") as! GeoPoint)){
//                            DispatchQueue.main.async {
//                                self.allRestaurants.append(restaurant)
//                            }
//                        }
                        self.allRestaurants.append(restaurant)
                    }
                    if(document == snapshot!.documents.last){
                        self.dispatchGroup.leave()
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

        if(locationManager.location != nil){
            
            let lat1 = coordinate.latitude * Double.pi/180
            let lat2 = locationManager.location!.coordinate.latitude * Double.pi/180
            
            let long1 = coordinate.longitude
            let long2 = locationManager.location!.coordinate.longitude
            
            let deltaLat = (lat2 - lat1) * Double.pi/180
            let deltaLong = (long2 - long1) * Double.pi/180
            
            let a = sin(deltaLat/2) * sin(deltaLat/2) + cos(long1) * cos(long2) * sin(deltaLong/2) * sin(deltaLong/2)
            
            
            let c = 2 * atan2(sqrt(a), sqrt(1-a))
            
            var d = Double(Eradius) * c
            print("first d:", d)
            
    //        return Double(d)
            
            d = Double(d * 0.00062137)
            print("second d:", d)
            
            return Double(Double(round(100*d)/100).removeZerosFromEnd())!
        }
        else{
            print("check: \(locationManager.location)")
            return 0.0
        }

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
