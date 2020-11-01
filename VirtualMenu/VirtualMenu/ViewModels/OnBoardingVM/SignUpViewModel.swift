//
//  SignUpViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/10/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices
import CryptoKit

class SignUpViewModel: ObservableObject {
    
    var alertMessage = ""
    var alertTitle = ""
    @Environment(\.window) var window: UIWindow?

    @State var socialLogin = SocialLogin()
    @State var currentNonce: String? = ""
    
    @State var delegate: SignInWithAppleDelegates! = nil
    @EnvironmentObject var user: UserStore

    let db = Firestore.firestore()
    
    func createUser(email: String, password: String, name: String) -> Bool{
        //        if self.isValidInputs() {
        print("valid")
        var bool = true
        Auth.auth().createUser(withEmail: email, password: password){
            (result, error) in
            if (error != nil){
                bool = false
            }
            else{
                let db = Firestore.firestore()
                db.collection("User").addDocument(data: ["email": email, "password": password, "username": name, "id": result!.user.uid]) {(error) in
                    if error != nil {
                        bool = false
                    }
                    
                }
                
            }
            bool = true
            print("created")
            //            }
            //
        }
        return bool
        
    }
    
    func fetchUserID(name: String, email: String, dispatch: DispatchGroup){
        print("start dispatch")
        let fb = Firestore.firestore()
    
        let ref = fb.collection("User")
    
        let query = ref.whereField("email", isEqualTo: email).whereField("username", isEqualTo: name)
        
        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            }
            else {
                for document in snapshot!.documents {
                    userProfile.userId = document.get("id") as! String
                    print("end dispatch")
                    dispatch.leave()
                }
            }
        }
    }
    
    func returnAlertTitle() -> String{
        return self.alertTitle
    }
    
    func returnAlertMessage() -> String{
        return self.alertMessage
    }


    func signUpUser(email: String, name: String, password: String, dispatch: DispatchGroup) -> String{
        print("here")
        if(!email.isValidEmail){
            return "Error" + "|" + "Not valid email!"
        }
        if(!password.isValidPassword){
            return "Error" + "|" + "Not valid email!"
        }
        let actionCode = ActionCodeSettings()
        actionCode.url = URL(string: "https://yumzzapp.page.link/connect")
        actionCode.handleCodeInApp = true
        actionCode.setIOSBundleID(Bundle.main.bundleIdentifier!)
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCode) { (error) in
//                            self.user.showOnboarding = false
            
            if let error = error {
                dispatch.leave()
                dispatch.notify(queue: .main){
                    self.alertMessage = error.localizedDescription
                    self.alertTitle = "Error!"
                }
              return
            }
            UserDefaults.standard.set(email, forKey: "Email")
            UserDefaults.standard.set(name, forKey: "Name")
            UserDefaults.standard.set(password, forKey: "Password")
            print("set")
            self.alertMessage = "A confirmation email was sent to \(email). Please click the link to sign in!"
            self.alertTitle = "Email Sent!"
            dispatch.leave()
            print("leave")
            
        }
        print("return: \(self.alertTitle)")
        return "A confirmation email was sent to \(email). Please click the link to sign in!" + "|" + "Email Sent!"
    }
    
    func signUpFb(dispatch: DispatchGroup) {
        facebook = true
        google = false
            socialLogin.attemptSignUpFb(completion: { result, error in
                if(error == nil){
                    print("attempt result")
                    self.alertMessage = "A confirmation email was sent to the email associated with the provided facebook account. Please click the link to sign in!"
                    self.alertTitle = "Email Sent!"
                    print("signupfb: \(self.alertMessage)  | \(self.alertTitle)")
                    dispatch.leave()
                }
                else{
                    //create alert saying no account associated with this FB profile. Please use sign up page
                    self.alertMessage = "\(error!.localizedDescription)"
                    self.alertTitle = "Error!"
                    dispatch.leave()

                }
            })
        }
        
        func randomNonceString(length: Int = 32) -> String {
          precondition(length > 0)
          let charset: Array<Character> =
              Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
          var result = ""
          var remainingLength = length

          while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
              var random: UInt8 = 0
              let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
              if errorCode != errSecSuccess {
                fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
              }
              return random
            }

            randoms.forEach { random in
              if remainingLength == 0 {
                return
              }

              if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
              }
            }
          }

          return result
        }
        
        func sha256(_ input: String) -> String {
          let inputData = Data(input.utf8)
          let hashedData = SHA256.hash(data: inputData)
          let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
          }.joined()

          return hashString
        }
        
        struct SocialLogin: UIViewRepresentable {
            var dispatch = DispatchGroup()

            
            func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
                return UIView()
            }
            
            func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
            }
            
            func attemptSignUpGoogle(dis: DispatchGroup) {
                signUp = true
                login = false
                GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
                GIDSignIn.sharedInstance()?.signIn()
                dis.leave()
            }
            
            func attemptSignUpFb(completion: @escaping (_ result: LoginManagerLoginResult?, _ error: Error?) -> Void) {
                print("attempt signup")
                let fbLoginManager: LoginManager = LoginManager()
                fbLoginManager.logOut()
                facebook = true
                google = false
                signUp = true
                login = false
                print("login")
                fbLoginManager.logIn(permissions: ["email"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
                    // print("RESULT: '\(result)' ")
                    if error != nil {
                        print("error")
                    }else if(result!.isCancelled){
                        print("result cancelled")
                    }else if(!result!.isCancelled){
                        //create a userProfile based on FB info
                        credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                        
                        print("success Get user information.")
                        

                        let fbRequest = GraphRequest(graphPath:"me", parameters: ["fields":"email, name, picture"])
                        fbRequest.start { (connection, infoResult, error) -> Void in
                            
                        if error == nil {
                            print("User Info : \(infoResult ?? "No result")")
                            print(infoResult.unsafelyUnwrapped)
                            print(credential!.description)
                            
                            if let infoResult = infoResult as? [String:Any],
                                let email: String = infoResult["email"] as? String,
                                let name: String = infoResult["name"] as? String,
                                let picture = infoResult["picture"] as? [String: Any],
                                let data = picture["data"] as? [String: Any],
                                let url = data["url"] as? String
                                {
                                UserDefaults.standard.set(email, forKey: "Email")
                                UserDefaults.standard.set(name, forKey: "Name")
    //                            let dispatchTwo = DispatchGroup()
                                let actionCode = ActionCodeSettings()
                                actionCode.url = URL(string: "https://yumzzapp.page.link/connect")
                                actionCode.handleCodeInApp = true
                                actionCode.setIOSBundleID(Bundle.main.bundleIdentifier!)
                                self.dispatch.enter()
                                
                                Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCode) { (error) in
        //                            self.user.showOnboarding = false
                                    if error != nil {
                                      return
                                    }
                                    userProfile.emailAddress = email
                                    userProfile.fullName = name
                                    userProfile.profilePhotoURL = url
                                    self.dispatch.leave()
                                }
                                self.dispatch.notify(queue: .main){
                                    completion(result, error)
                                    return
                                }

                            }
                        } else {
                            print("Error Getting Info \(error ?? "error" as! Error)");
                            completion(result, error)
                            return
                            }
                        }
                    }
                }
            }
        }

}
