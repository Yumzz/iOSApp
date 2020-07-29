//
//  DishAdminView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

struct DishAdminView: View {
    @State var description: String = ""
    @State var name: String = ""
    @State var price: String = ""
    @State var restaurant: String = ""
    @State var type: String = ""

    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State var show = false
    @State private var alertTitle = ""
    
    
    var body: some View {
            VStack{
                VStack(spacing: 30){
                CustomTextField(strLabel: "Description", strField: $description, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                CustomTextField(strLabel: "Name", strField: $name, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                    CustomTextField(strLabel: "Price", strField: $price, uiTextAutoCapitalizationType: .none, uiKeyboardType: .decimalPad)
                CustomTextField(strLabel: "Restaurant", strField: $restaurant, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                CustomTextField(strLabel: "Type", strField: $type, uiTextAutoCapitalizationType: .none, uiKeyboardType: .emailAddress)
                }
                                
                VStack{
                Button(action: {
                        if isValidInput(inputVal: self.description) && isValidInput(inputVal: self.name) && isValidInput(inputVal: self.restaurant) && isValidInput(inputVal: self.type){
                            let url = URL(string: Constants.baseURL.api + "/dishAdd")!
                            var request = URLRequest(url: url)
                            request.httpMethod = "POST"
                            let bodyData = "Name=\(self.name)&Description=\(self.description)&Price=\(self.price)&Type=\(self.type)&Restaurant=\(self.restaurant)"
                            print(bodyData)
                            request.httpBody = bodyData.data(using: .utf8)

                            URLSession.shared.dataTask(with: request) { data, response, error in
                                guard let httpResponse = response as? HTTPURLResponse,
                                      (200...299).contains(httpResponse.statusCode) else {
                                        self.showingAlert = true
                                        self.show.toggle()
                                        self.alertTitle = "Network Error"
                                        self.alertMessage = "There was a Network Error while processing your request"
                                    return
                                }
                                self.show.toggle()
                                self.showingAlert = true
                                self.alertTitle = "Request Submitted!"
                                self.alertMessage = "Our team will respond shortly"
                            }.resume()
                        } else {
                            self.show.toggle()
                            self.showingAlert = true
                            self.alertTitle = "Missing Field(s)"
                            self.alertMessage = "Please ensure all three fields are filled out"
                        }
                }){
                    Text("Enter Data")
                }.alert(isPresented: $showingAlert) {
                    Alert(title: Text("Thank you for submitting"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                }
            }
            }
    }
}

struct DishAdminView_Previews: PreviewProvider {
    static var previews: some View {
        DishAdminView()
    }
}
