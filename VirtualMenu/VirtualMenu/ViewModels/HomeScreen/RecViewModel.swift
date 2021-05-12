//
//  RecViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/11/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase

class RecViewModel: ObservableObject {
    
    
    func getRecommendation(tp: [Int]){
        let url = URL(string: "https://yumzztasteprofile.azurewebsites.net/api/YumzzPredictionAPI?code=w23ua6KI/KL4Nkj2VeVevK4GzM4Nvuo/PU5ceQWQsAuc35rHDdwW8A==")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let bodyData = "taste_profile=4#0#0#2#3#4"
        print(bodyData)
        request.httpBody = bodyData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
//                    title = "Network Error"
//                    result = "There was a Network Error while processing your request"
                    return
            }
//            title = "Request Submitted!"
//            result = "Our team will respond shortly"
        }.resume()
    }
    
    
    
    
}
