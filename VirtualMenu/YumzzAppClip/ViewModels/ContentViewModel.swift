//
//  ContentViewModel.swift
//  YumzzAppClip
//
//  Created by Rohan Tyagi on 1/19/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation


class ContentViewModel: ObservableObject {
    
    @Published var restaurant: RestaurantFB? = nil
    let dishDispatch = DispatchGroup()
    
    let buildDispatch = DispatchGroup()

    
    func fetchStuff(dis: DispatchGroup){
        print("start fetch stuff")
        let x = ["id":"Bd2fiejnVscgFrJJOidp"]
        let jsonData = try? JSONSerialization.data(withJSONObject: x)

        let url = URL(string: (Constants.baseURL.api + "/getRestaurant"))!
        
        print(url.absoluteString)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        print("before task")
        let task1 = URLSession.shared.dataTask(with: request) {(data, response, error) in
            print("start task")
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            guard let data = data else { print("e"); return }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            self.restaurant = RestaurantFB(json: json!)!
            print("\(self.restaurant)")
            print("\(self.restaurant?.ethnicity)")
            print("stop task: \(self.restaurant!.name)")
            
        }
        task1.resume()
        let url2 = URL(string: Constants.baseURL.api + "/getDishes")!
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "POST"
        request2.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request2.httpBody = jsonData
        let task2 = URLSession.shared.dataTask(with: request2) {(data, response, error) in
            print("start task")
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                }

            guard let data = data else { print("ee"); return }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            //take data from json and create a dish from each
//            self.dishDispatch.enter()
            print("json1: \(json)")
            print("stop task")
        }
        task2.resume()
        let url3 = URL(string: Constants.baseURL.api + "/getBuilds")!
        var request3 = URLRequest(url: url3)
        request3.httpMethod = "POST"
        request3.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request3.httpBody = jsonData
        let task3 = URLSession.shared.dataTask(with: request3) {(data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                }

            guard let data = data else { print("ee3"); return }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            print("json2:\(json)")
            //take data from json and create a dish from each
        
//            if(json != nil){
//                self.createBuilds(json: json!)
//            }
            print("stop task")
            print("finish fetch stuff")
            
            dis.leave()

        }
        task3.resume()
    }
    
    func createDishes(json: [[String:String]]){
        for x in json{
            if(self.restaurant?.dishes == nil){
                self.restaurant?.dishes = []
            }
            self.restaurant?.dishes!.append(DishFB(json: x)!)
        }
        self.dishDispatch.leave()
    }
    func createBuilds(json: [[String:String]]){
        for x in json{
            if(self.restaurant?.builds == nil){
                self.restaurant?.builds = []
            }
            self.restaurant?.builds!.append(BuildFB(json: x)!)
        }
    }
}
