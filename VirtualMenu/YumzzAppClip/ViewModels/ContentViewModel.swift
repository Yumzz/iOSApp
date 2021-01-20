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
    @Published var dishes: [DishFB]? = nil
    
    
    func fetchStuff(dis: DispatchGroup){
        dis.enter()
        print("start fetch stuff")
        let url = URL(string: Constants.baseURL.api + "/getRestaurant")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        print("before task")
        _ = URLSession.shared.dataTask(with: request) {(data, response, error) in
            print("start task")
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                }
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            self.restaurant = RestaurantFB(json: json!)!
            print("stop task")
        }
        let url2 = URL(string: Constants.baseURL.api + "/getDishes")!
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "GET"
        _ = URLSession.shared.dataTask(with: request2) {(data, response, error) in
            print("start task")
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                }
            
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            //take data from json and create a dish from each
            self.createDishes(json: json!)
            print("stop task")
        }
        let url3 = URL(string: Constants.baseURL.api + "/getBuilds")!
        var request3 = URLRequest(url: url3)
        request3.httpMethod = "GET"
        _ = URLSession.shared.dataTask(with: request3) {(data, response, error) in
            if let error = error {
                print("Error took place \(error)")
                return
            }
            if let response = response as? HTTPURLResponse {
                    print("Response HTTP Status code: \(response.statusCode)")
                }
            
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            //take data from json and create a dish from each
            self.createBuilds(json: json!)
            print("stop task")
            print("finish fetch stuff")
            dis.leave()
        }
    }
    
    func createDishes(json: [[String:String]]){
        for x in json{
            if(self.restaurant?.dishes == nil){
                self.restaurant?.dishes = []
            }
            self.restaurant?.dishes!.append(DishFB(json: x)!)
        }
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
