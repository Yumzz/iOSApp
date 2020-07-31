//
//  FirebaseFunctionsViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

class FirebaseFunctionsViewModel: ObservableObject {
    
    func contactUsButton(email: String, name: String, messageBody: String) -> [String] {
        var result = ""
        var title = ""
            
        if isValidInput(inputVal: email) && isValidInput(inputVal: name) && isValidInput(inputVal: messageBody) {
            let url = URL(string: Constants.baseURL.api + "/feedback")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let bodyData = "name=\(name)&email=\(email)&message=\(messageBody)&Type=Contact"
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
            result = "Please ensure all three fields are filled out"
        }
        return [result, title]
        
    }
    
    
    func reportProblemButton(email: String, name: String, messageBody: String) -> [String] {
        var result = ""
        var title = ""
            
        if isValidInput(inputVal: email) && isValidInput(inputVal: name) && isValidInput(inputVal: messageBody) {
            let url = URL(string: Constants.baseURL.api + "/feedback")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let bodyData = "name=\(name)&email=\(email)&message=\(messageBody)&Type=Problem"
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
            result = "Please ensure all three fields are filled out"
        }
        return [result, title]
    }
    
    func suggestRestaurantButton(email: String, messageBody: String, name: String) -> [String]{
        var result = ""
        var title = ""
        
        if isValidInput(inputVal: email) && isValidInput(inputVal: name) && isValidInput(inputVal: messageBody) {
            let url = URL(string: Constants.baseURL.api + "/feedback")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let bodyData = "name=\(name)&email=\(email)&message=\(messageBody)&Type=Suggest"
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
            result = "Please ensure all three fields are filled out"
        }
        return [result, title]
    }
    
    
}
