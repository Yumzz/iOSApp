//
//  ReportProblemViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/10/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

class ReportProblemViewModel: ObservableObject{
    
    @State var alertMessage = ""
    @State var alertTitle = ""
    
    func sendResponse(email: String, messageBody: String, name: String, disp: DispatchGroup){
        disp.enter()
        let results = self.reportProblemButton(email: email, name: name, messageBody: messageBody)
        let result = results[0]
        let title = results[1]
        print(result)
        if(result == ""){
            disp.leave()
            disp.notify(queue: .main){
                return
            }
        }
        else{
            disp.leave()
            disp.notify(queue: .main){
                self.alertTitle = title
                self.alertMessage = result
            }
        }
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
}
