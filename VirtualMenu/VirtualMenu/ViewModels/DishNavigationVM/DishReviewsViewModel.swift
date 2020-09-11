//
//  DishReviewsViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/10/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

class DishReviewsViewModel: ObservableObject {
    
    func addReview(body: String, dish: DishFB, rest: RestaurantFB, starRating: Int, userID: String, username: String) -> [String] {
        var result = ""
        var title = ""

        if isValidInput(inputVal: body){
            let url = URL(string: Constants.baseURL.api + "/reviewAdd")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let bodyData = "Body=\(body)&DishID=\(dish.key)&RestID=\(rest.key)&StarRating=\((starRating))&Username=\(username)&UserID=\(userID)"
            print(bodyData)
            request.httpBody = bodyData.data(using: .utf8)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                        title = "Network Error"
                        result = "There was a Network Error while processing your request"
                        return
                }
                title = "Request Submitted!"
                result = "Our team will respond shortly"
            }.resume()
        } else {
            title = "Missing Field(s)"
            result = "Please ensure both fields are filled out"
        }
        return [result, title]
        
    }
    
    
    
    
    
    
    
    
}
