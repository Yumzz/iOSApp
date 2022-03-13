//
//  RecCardVM.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 2/27/22.
//  Copyright © 2022 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class RecCardVM: ObservableObject {
    @State var ff = ""
    @State var dishIngredString = ""
    @State var dishes = []
    private var db = Firestore.firestore()
    let unNecessaries: Set<String> = ["and", "or", "but", "with", "is", "this", "enjoy", "a", "-", "of", "from", "side", "with", "in", "served", "\"", "choice", "it", "both", "come", "2", "option", "our", "$", "has", "your", "1", "6", "3", "4", "5", "7", "8", "9"]
    
    func getLocalDishes(){
//        let db = Firebase.Firestore()
        //get 20 documents
        //maybe do a check for the restaurants within range and get dishes only from those rests
        let docRef = db.collection("Dish").whereField("Description", notIn: ["", " "]).limit(to: 40)
        docRef.getDocuments { [self] qsnap, err in
            for doc in qsnap!.documents{
//                dishes.append(doc)
                let dish = DishFB(snapshot: doc)!
                self.dishes.append(dish)
//                dishIngredString +=
                let descript = doc.data()["Description"] as! String
                var d = descript.split(separator: " ")
                d.removeAll(where: {unNecessaries.contains($0.lowercased())})
                for di in d{
                    self.dishIngredString += di
//                    if(di == d.last){
//                        self.dishIngredString += ";"
//                        print("DishIngred2: \(self.dishIngredString)")
//                    }
                }
                self.dishIngredString += ";"
                print("DishIngred: \(self.dishIngredString)")
                
//                doc.data()
            }
        }
    }
    
    func compareDishes(userTP: String) -> [Int]{
        var maxDishes : Set<DishFB> = []
        getLocalDishes()
        guard let url = URL(string: "https://yumzztasteprofile.azurewebsites.net/api/YumzzPredictionAPIV2?code=k3EK4IBtnVunHEZD0M07LJrZgk90Mq9usP9tg8Am5mSN9jytHsIkpg==&user_tp_raw=\(userTP)&dishes_tp_raw=\(self.dishIngredString)beef,fish;fish,japanese;chinese,noodle,hotpot") else {
        //                        print("Invalid URL")
            return
        }

        var compareRequest = URLRequest(url: url)
        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: compareRequest) { data, urlresponse, err in
            if let err = err {
                print("Request error: \(err)")
            }
            guard let response = response as? HTTPURLResponse else {return}

            if response.statusCode == 200 {
                guard let data = data else{ return }
                DispatchQueue.main.async {
                    do {
                        let decodedRatings = try! decoder.decode([Float].self, from: data)
//                        min
                        //need to get top 5 dishes' indexes -> return dishes at those indexes
                        //
                        //create a set of maxdishes, insert when above min, keep min dish index, remove [maxdishes.remove(at: maxes[min])] when dish no longer a max dish, rewrite min and min dish index accordingly

                        var minIndex = 0
                        var min = 0
                        var dRIndex = -1
                        for dR in decodedRatings{
                            dRIndex += 1
                            if(dR > min){
                                maxDishes.insert(dishes[dRIndex])
                                if(minIndex > -1){
                                    
                                }
                            }

//                            for max
//                            maxDishes.insert()
//                            decodedRatings.
                        }
                    }
                    catch let err {
                        print("Error decoding: ", err)
                    }
                }
            }
            dataTask.resume()
        }
//        print("choicesurl: \(url)")

//        let (data, _) = try await URLSession.shared.data(from: url)
//        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
//            results = decodedResponse.results
//        }

        //
//                        let (data, _) = try await URLSession.shared.data(from: url)
        //
        //                    if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
        //                        results = decodedResponse.results
        //                    }
    }
    
//    func getDistFromUser(coordinate: GeoPoint) -> Double {
//        //haversine formula - distance in miles
//        //        const R = 6371e3; // metres
//        //        const φ1 = lat1 * Math.PI/180; // φ, λ in radians
//        //        const φ2 = lat2 * Math.PI/180;
//        //        const Δφ = (lat2-lat1) * Math.PI/180;
//        //        const Δλ = (lon2-lon1) * Math.PI/180;
//        //
//        //        const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
//        //                  Math.cos(φ1) * Math.cos(φ2) *
//        //                  Math.sin(Δλ/2) * Math.sin(Δλ/2);
//        //        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
//        //
//        //        const d = R * c; in meters
//        //d = d x 0.00062137 in miles
//
//        let lat1 = coordinate.latitude * Double.pi/180
//        let lat2 = locationManager.location!.coordinate.latitude * Double.pi/180
//        print("lat1: \(lat1)")
//        print("lat2: \(lat2)")
//        let long1 = coordinate.longitude * Double.pi/180
//        let long2 = locationManager.location!.coordinate.longitude * Double.pi/180
//        print("long1: \(long1)")
//        print("long2: \(long2)")
//        let deltaLat = (lat2 - lat1) * Double.pi/180
//        let deltaLong = (long2 - long1) * Double.pi/180
//        print("deltalat: \(deltaLat)")
//        print("deltalong: \(deltaLong)")
//        let a = sin(deltaLat/2) * sin(deltaLat/2) + cos(long1) * cos(long2) * sin(deltaLong/2) * sin(deltaLong/2)
//        print("a: \(a)")
//
//        let c = 2 * atan2(sqrt(a), sqrt(1-a))
//        print("c: \(c)")
//
//        let d = Double(Eradius) * c
//        print("d: \(d)")
//
//        print("distance: \(Double(d * 0.00062137))")
//        return Double(d * 0.00062137)
//    }
    
    
//    func checkInRadius(coordinate: GeoPoint) -> Bool {
//        let dist = self.getDistFromUser(coordinate: coordinate)
//        if(dist <= Double(proximity)){
//            return true
//        }
//        else {
//            return false
//        }
//    }
    
}

