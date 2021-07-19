//
//  ContentViewModel.swift
//  YumzzAppClip
//
//  Created by Rohan Tyagi on 1/19/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation


class ContentViewModel: ObservableObject {
    
    var restaurant: RestaurantFB? = nil

    let restDispatch = DispatchGroup()
    let dishDispatch = DispatchGroup()
    let buildDispatch = DispatchGroup()
    
    let d = DispatchGroup()
    
    init(dis: DispatchGroup, id: String){
        dis.enter()
        
        self.fetchStuff(dis: d, id: id)
        
        d.notify(queue: .main){
            dis.leave()
        }
        
    }
    
//    func fetchStuff(dis: DispatchGroup, id: String){
//        print("fetch")
//        let x = ["id":id]
//        let jsonData = try? JSONSerialization.data(withJSONObject: x)
//
//        let urls = [URL(string: (Constants.baseURL.api + "/getRestaurant"))!, URL(string: Constants.baseURL.api + "/getBuilds")!, URL(string: Constants.baseURL.api + "/getDishes")!]
//
//        for url in urls {
//            dis.enter()
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonData
//            print(request)
//            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
//                if let error = error {
//                    print("Error took place \(error)")
//                    return
//                }
//                if let response = response as? HTTPURLResponse {
//                    print("Response HTTP Status code: \(response.statusCode)")
//                }
//                guard let data = data else { print("e"); return }
//                print("aaa")
//                if url == urls[0] {
//                    print(url)
//                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
//                    self.restaurant = RestaurantFB(json: json!)!
//                }
//                if url == urls[1] {
//                    print(url)
//                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
//                    self.createBuilds(json: json!)
//                }
//                if url == urls[2] {
//                    print(url)
//                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
//                    self.createDishes(json: json!)
//                }
//            }
//            task.resume()
//            dis.leave()
//        }
//
//
//    }
    
    func fetchStuff(dis: DispatchGroup, id: String){
        dis.enter()
        self.restDispatch.enter()
        print("start fetch stuff")
        let x = ["id":id]
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
            print("start rest")
            self.restaurant = RestaurantFB(json: json!)!
            print("\(self.restaurant)")
            print("\(self.restaurant?.ethnicity)")
            print("stop task: \(self.restaurant!.name)")
            self.restDispatch.leave()

        }
        task1.resume()
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
            print("data: \(try? JSONSerialization.jsonObject(with: data, options: []).self)")
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
            print("json2:\(json)")
            //take data from json and create a build from each
//            if(json != nil){
//                self.createBuilds(json: json!)
//            }
            self.restDispatch.notify(queue: .main){
                print("start build")
                self.buildDispatch.enter()
                
                self.createBuilds(json: json!)
                print("stop task")
                print("finish fetch stuff")
            }
//            self.dishDispatch.notify(queue: .main){
//                print("dd notifi")
//                self.buildDispatch.enter()
//                self.createBuilds(json: json!)
//                self.buildDispatch.notify(queue: .main){
////                        print("buildCount: \(self.restaurant?.builds?.count)")
//            self.buildDispatch.notify(queue: .main){
//                print("dishes: \(self.restaurant?.dishes)")
//                print("builds: \(self.restaurant?.builds)")
//            }
//            self.buildDispatch.leave()
//
//                    dis.leave()
//                }
//            }

        }
        task3.resume()
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
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
            //take data from json and create a dish from each
            print("json1:\(json)")
            self.buildDispatch.notify(queue: .main){
                print("dd notifi")
                print("start dishes")
                self.dishDispatch.enter()
                self.createDishes(json: json!)
                self.dishDispatch.notify(queue: .main){
//                        print("buildCount: \(self.restaurant?.builds?.count)")
                    print("dishes: \(self.restaurant?.dishes)")
                    print("builds: \(self.restaurant?.builds)")

                    dis.leave()
                }
            }
        }
        task2.resume()



    }
    
    func createDishes(json: [[String:Any]]){
        for x in json{
            if(self.restaurant?.dishes == nil){
                self.restaurant?.dishes = []
            }
            print("new dish")
            self.restaurant?.dishes!.append(DishFB(json: x)!)
        }
        print("done")
        self.dishDispatch.leave()
    }
    func createBuilds(json: [[String:Any]]){
        print("enter")
        for x in json{
            if(self.restaurant?.builds == nil){
                self.restaurant?.builds = []
            }
            self.restaurant?.builds!.append(BuildFB(json: x)!)
        }
        self.buildDispatch.leave()
    }
}
