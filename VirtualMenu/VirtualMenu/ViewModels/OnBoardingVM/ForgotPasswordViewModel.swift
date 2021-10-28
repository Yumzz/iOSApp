//
//  ForgotPasswordViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/10/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

class ForgotPasswordViewModel: ObservableObject {
    
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    func passwordReset(email: String) -> String{
        var string = ""
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if(error != nil){
                string = "Error. Email could not be sent to provided address."
            }
            else{                
                string = ""
            }
        }
        return string
    }
    
    func forgotPasswordValidInputs(email: String) -> String {
        if email == "" {
            return "Email can't be blank."
        } else if !email.isValidEmail {
            return "Email is not valid."
        }
        return ""
    }
    
    
    
}
