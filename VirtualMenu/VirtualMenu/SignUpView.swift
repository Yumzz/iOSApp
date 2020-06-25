//
//  SignUpView.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 6/24/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    
    var body: some View {
            
            VStack {
                
                VStack {
                    Spacer(minLength: (UIScreen.main.bounds.width * 15.0) / 414.0)
                    
//                    Logo + Name
                                        
                    VStack {
                        
                        Spacer(minLength: (UIScreen.main.bounds.width * 15) / 414)

                        Logo()
                                                
                        VStack(spacing: 0) {
                            
                            Text("Name")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                            
                            TextField("", text: $name)
                                .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                                .imageScale(.small)
                                .autocapitalization(UITextAutocapitalizationType.words)
                            
                            Divider()
                            .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                            .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                        }
    //                    seperator()
                    }
                    
                    Spacer(minLength: (UIScreen.main.bounds.width * 15) / 414)
                    
                    VStack {
                        
                        VStack(spacing: 0) {
                            
                            Text("Email")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                
                            
                            TextField("", text: $email)
                                .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                                .imageScale(.small)
                            .keyboardType(.emailAddress)
                            .autocapitalization(UITextAutocapitalizationType.none)
                            
                            Divider()
                            .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                            .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                        }
    //                    seperator()
                        
                    }
                    
                    Spacer(minLength: (UIScreen.main.bounds.width * 15) / 414)
                    
                    VStack{
                        
                        VStack(spacing: 0) {
                            Text("Password")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                
                                
                            
                            SecureField("", text: $password)
                                .frame(height: (UIScreen.main.bounds.width * 40) / 414, alignment: .center)
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                                .font(.system(size: (UIScreen.main.bounds.width * 15) / 414, weight: .regular, design: .default))
                                .imageScale(.small)
                            
                            Divider()
                            .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                            .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                        }
                        //                    seperator()
                    }
                    
                    
                    VStack {
                        Spacer()
                            .frame(height: 10)
                        CustomButton(action: {
    //                        if  self.isValidInputs() {
                               
                                // For use with property wrapper
    //                            UserDefaults.standard.set(true, forKey: "LoggedIn")
    //                            UserDefaults.standard.synchronize()
    //
    //                            let url = URL(string: Constants.baseURL.api + "/login")!
    //                            var request = URLRequest(url: url)
    //                            request.httpMethod = "POST"
    //                            let bodyData = "email=\(self.email)&password=\(self.password)"
    //                            print(bodyData)
    //                            request.httpBody = bodyData.data(using: .utf8)
    //
    //                            URLSession.shared.dataTask(with: request) { data, response, error in
    //                                guard let httpResponse = response as? HTTPURLResponse,
    //                                      (200...299).contains(httpResponse.statusCode) else {
    //                                        self.showAlert = true
    //                                        self.alertTitle = "Network Error"
    //                                        self.alertMessage = "There was a Network Error while processing your request"
    //                                    return
    //                                }
    //                                guard let data = data, error == nil else { return }
    //
    //                                let json = try? JSONSerialization.jsonObject(with: data, options: [])
    //                                if let dictionary = json as? [String: Any] {
    //                                    if let success = dictionary["success"] as? Bool {
    //                                        if success {
    //                                            print("Would go to new view")
    //                                            // Go to ContentView()
    //                                        }
    //                                    }
    //                                }
    //
    //                                self.showAlert = true
    //                                self.alertTitle = "Request Submitted!"
    //                                self.alertMessage = "Our team will respond shortly"
    //                            }.resume()
    //                        } else {
    //                            self.showAlert = true
    //                            self.alertTitle = "Missing Field(s)"
    //                            self.alertMessage = "Please ensure all three fields are filled out"
    //                        }
                        })
                        {
                            Text("SIGN UP")
                                .foregroundColor(.green)
                        }
                        .frame(width: 100)

                    }
                    
                    HStack{
                        
                        VStack{
                            Divider()
                                .padding(.leading, (UIScreen.main.bounds.width * 40) / 414)
                                .frame(width: (UIScreen.main.bounds.width/2.3), height: 10, alignment: .leading)

                        }
                        
                        Text("OR")
                        
                        VStack{
                             Divider()
                               .padding(.trailing, (UIScreen.main.bounds.width * 40) / 414)
                               .frame(width: (UIScreen.main.bounds.width/2.3), height: 10, alignment: .trailing)
                           }
                        
                    }
                    
                    VStack(spacing: 10){
                        Spacer()
                            .frame(height: 10)
                        CustomButton(action: {
//                            self.showAlert.toggle()

                        }){
                            HStack{
                                Image("continue_with_google")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                Text("CONTINUE WITH GOOGLE")
                                .foregroundColor(.green)
                            }
                        }
                        CustomButton(action: {
//                            self.showAlert.toggle()

                        }){
                            HStack{
                                Image("continue_with_facebook")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                Text("CONTINUE WITH FACEBOOK")
                                .foregroundColor(.green)
                            }
                        }
                        
                        Spacer()
                    }
                }
                
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
