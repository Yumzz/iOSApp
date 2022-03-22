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
    var dishIngredString = ""
    var dishes : [DishFB] = []
    var maxes : [DishFB] = []
    private var db = Firestore.firestore()
    let unNecessaries: Set<String> = ["and", "or", "but", "with", "is", "this", "enjoy", "a", "-", "of", "from", "side", "with", "in", "served", "\"", "choice", "it", "both", "come", "option", "our", "$", "has", "your", "costs", "cost", ".", "kids", "for", "the", "day", "one", "starter", "delicious", "cup", "half", "season", "&", "there"]
    
    let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "\""]
    
    func getLocalDishes(dp: DispatchGroup){
//        let db = Firebase.Firestore()
        //get 20 documents
        //maybe do a check for the restaurants within range and get dishes only from those rests
        //need to get their restaurants' ethnicity
        var dIngred = ""
        let docRef = db.collection("Dish").whereField("Description", notIn: ["", " "]).limit(to: 40)
        docRef.getDocuments { [self] qsnap, err in
            var s = ""
            var dis: [DishFB] = []
            for doc in qsnap!.documents{
//                dishes.append(doc)
                DispatchQueue.main.async {
                    
                    let dish = DishFB(snapshot: doc)!
                    dis.append(dish)
                    
                    var ethnicity = ""
                    
                    let gr = DispatchGroup()
                    gr.enter()
                    let restRef = db.collection("Restaurant").whereField("Name", isEqualTo: dish.restaurant) .limit(to: 1)
                    restRef.getDocuments { [self] qsnap, err in
                        //need to get their restaurants' ethnicity and add to dsh
                        for qdoc in qsnap!.documents{
                            
                            ethnicity = qdoc.data()["Ethnicity"] as! String + ", "
                            gr.leave()
                        }
                        
                    }
                    
    //                dishIngredString +=
    //                print("name: \(dish.name)")
                    gr.notify(queue: .main){
                        let descript = dish.description
                        
        //                print("descript: \(descript)")
                        var d = descript.split(separator: " ")
        //                print("split: \(d)")
                        d.removeAll(where: {unNecessaries.contains($0.lowercased().trim)})
                        for n in nums {
                            d.removeAll(where: {$0.contains(n)})
                        }
                        print("d: \(d)")
                        for di in d{
        //                    print("di: \(type(of: di))")
                            var str = String(di)
        //                    print("di: \(type(of: str))")
                            if(str.contains(",")){
                                str = String(str.dropLast())
                            }
                            else if(str.contains(".")){
                                str = String(str.dropLast())
                            }
                            else if(str.contains("!")){
                                str = String(str.dropLast())
                            }
                            else if(str.contains("?")){
                                str = String(str.dropLast())
                            }
                            
                            s += str + ", "
                            print("diString: \(s)")
        //                    if(di == d.last){
        //                        self.dishIngredString += ";"
        //                        print("DishIngred2: \(self.dishIngredString)")
        //                    }
                        }
                        s += ", " + ethnicity
                        s = String(s.dropLast())
                        s = String(s.dropLast())
                        s += "; "
    //                    self.dishIngredString += s
                        print("s: \(s)")

                        if(doc == qsnap!.documents.last){
                            self.dishIngredString = s
                            self.dishIngredString = String(self.dishIngredString.dropLast())
                            self.dishes = dis
                            dp.leave()
                        }
                    }
//                doc.data()
                }
            
            }
//            dp.leave()
//        print("finals: \(s)")
            
//            self.dishIngredString = s
//            print("dishIngred: \(self.dishIngredString)")
            
        }
//        return dIngred
        
    }
    
    func compareDishes(userTP: String, disp: DispatchGroup){
        var maxDishes : [DishFB] = []
        var maxValues : [Float] = []
        let dGroup = DispatchGroup()
        dGroup.enter()
        getLocalDishes(dp: dGroup)
        dGroup.notify(queue: .main){
            print("url: https://yumzztasteprofile.azurewebsites.net/api/YumzzPredictionAPIV2?code=k3EK4IBtnVunHEZD0M07LJrZgk90Mq9usP9tg8Am5mSN9jytHsIkpg==&user_tp_raw=\(userTP)&dishes_tp_raw=\(self.dishIngredString)")


            let newString = self.dishIngredString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
//
//
            let tp = userTP.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            let str = "https://yumzztasteprofile.azurewebsites.net/api/YumzzPredictionAPIV2?code=k3EK4IBtnVunHEZD0M07LJrZgk90Mq9usP9tg8Am5mSN9jytHsIkpg==&user_tp_raw=\(tp!)&dishes_tp_raw=\(newString!)"

            print("str: \(str)")
//            let components = String.transformURLString(str)
//            print("ho: \(newString)")
//            print("compourl: \(components?.url)")
            guard let url = URL(string: str) else {
                //beef,fish;fish,japanese;chinese,noodle,hotpot

                print("Invalid URL")
                return
            }
            var compareRequest = URLRequest(url: url)
            compareRequest.httpMethod = "GET"
            print("compareRequest: \(compareRequest.description)")
            let dataTask = URLSession.shared.dataTask(with: compareRequest) { data, response, err in
                if let err = err {
                    print("Request error: \(err)")
                }
                print("in datatask dishes: \(self.dishes)")
                guard let resp = response as? HTTPURLResponse else {return}

                if resp.statusCode == 200 {
                    guard let data = data else{ return }
                    DispatchQueue.main.async { [self] in
                        do {
                            let decodedRatings = try! JSONDecoder().decode([Float].self, from: data)
    //                        min
                            print("decoded: \(decodedRatings)")
                            //need to get top 5 dishes' indexes -> return dishes at those indexes
                            //
                            //create a set of maxdishes, insert when above min, keep min dish index, remove [maxdishes.remove(at: maxes[min])] when dish no longer a max dish, rewrite min and min dish index accordingly
                            var minIndex = 0
    //                        Set<DishFB>.Index
                            var min = decodedRatings[0]
                            for x in 0 ... 4 {
                                maxDishes.append(self.dishes[x])
//                                maxDishes[x] = self.dishes[x]
                                maxValues.append(decodedRatings[x])
//                                maxValues[x] = decodedRatings[x]
                                if(min > decodedRatings[x]){
                                    min = decodedRatings[x]
                                    minIndex = x
                                }
                            }

                            var dRIndex = 4
                            for dR in decodedRatings[5...]{
                                dRIndex += 1
                                if(dR >= min){
                                    maxDishes[minIndex] = self.dishes[dRIndex]
                                    maxValues[minIndex] = decodedRatings[dRIndex]
                                    for d in maxValues {
                                        if d < min {
                                            min = d
                                            minIndex = maxValues.firstIndex(of: d)!
                                        }
                                    }
                                }
                            }
                            self.maxes = maxDishes
//                            print("maxDishes: \(self.maxes)")
                            disp.leave()
                            return
                        }
                        catch let err {
                            print("Error decoding: ", err)
                        }
                    }
                }

            }
            dataTask.resume()
//            dataTask.end
        }
        
//        print("choicesurl: \(url)")
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

