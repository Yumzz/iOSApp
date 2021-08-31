//
//  LoginViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 9/10/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseStorage
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import AuthenticationServices
import CryptoKit

var userProfile: UserProfile = UserProfile(userId: "", fullName: "", emailAddress: "", profilePicture: "", profPhoto: nil)

class LoginViewModel: ObservableObject {

    var alertMessage = ""
    var alertTitle = ""
    @Environment(\.window) var window: UIWindow?

    @State var socialLogin = SocialLogin()
    @State var currentNonce: String? = ""
    
    @State var delegate: SignInWithAppleDelegates! = nil
    @EnvironmentObject var user: UserStore
    
    let db = Firestore.firestore()
    
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
    
    func isValidInputs(email: String, password: String) -> String {
        if email == "" {
            return "Email can't be blank."
        } else if !email.isValidEmail {
            return "Email is not valid."
        } else if password == "" {
            return "Password can't be blank."
        } else if !(password.isValidPassword) {
            return "Please enter valid password"
        }
        return ""
    }

    func ridProfile(){
        userProfile = UserProfile(userId: "", fullName: "", emailAddress: "", profilePicture: "", profPhoto: nil)
    }

    func loginUser(email: String, password: String, disp: DispatchGroup? = nil){
//        if(!email.isValidEmail || !password.isValidPassword){
//            print("invalid")
//            self.alertMessage = "Your email or password is invalid"
//            self.alertTitle = "Sign in error"
//            disp?.leave()
//        }else{
            Auth.auth().signIn(withEmail: email, password: password.MD5){ result, error in
                // print("signin attempt:String(describing:  \(res)ult)")
                if(error != nil){
                    print(error!)
//                    if(start!){
//                        disp!.leave()
//                        disp?.notify(queue: .main){
//                            self.alertMessage = "Your email or password is incorrect"
//                            self.alertTitle = "Sign in error"
//                        }
//                    }
//                    else{
                        disp!.leave()
                        disp!.notify(queue: .main){
                            self.alertMessage = "Your email or password is incorrect"
                            self.alertTitle = "Sign in error"
                        }
//                    }
                }
                else{
//                    if(start!){
//                        disp!.leave()
//                        self.updateProfile()
//                    }
//                    else{
                
                        self.updateProfile(dispatch: disp)
                    }
//                    }
                }

    }

    
    func updateProfile(dispatch: DispatchGroup? = nil) {
        
        let storage = Storage.storage()
        let imagesRef = storage.reference().child("profilephotos/\(Auth.auth().currentUser!.uid)")
        
        Utils.getUserProfileImgURL(userId: Auth.auth().currentUser!.uid, completionHandler: { (res) in
            userProfile.profilePhotoURL = res
        })
        
        userProfile.userId = Auth.auth().currentUser!.uid
        print("updatingggg")
        print(Auth.auth().description)
        print(Auth.auth().currentUser?.observationInfo)
        userProfile.emailAddress = Auth.auth().currentUser!.email ?? ""
        
        
        let fb = Firestore.firestore()
        let ref = fb.collection("User")
        
        let query = ref.whereField("uid", isEqualTo: userProfile.userId).whereField("email", isEqualTo: userProfile.emailAddress)
        
        query.getDocuments { (snapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
        } else {
            for document in snapshot!.documents {
                userProfile.fullName = (document.get("username") as? String)!
            }
        }
        }
        
        //finishes after return is given as it is a little slow
        DispatchQueue.main.async {
            imagesRef.getData(maxSize: 2 * 2048 * 2048) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    userProfile.profilePhoto = UIImage(imageLiteralResourceName: "profile_photo_edit")
                    print(error.localizedDescription)
                } else {
                    // Data for "profilephotos/\(uid).jpg" is returned
                    // print("data: \(data)")
                    userProfile.profilePhoto = UIImage(data: data!)!
                    }
                if(dispatch != nil){
                print("leave")
                dispatch!.leave()
                }
            }
        }
        //        DispatchQueue.main.async {
        //        }
        print("updated")
        print(userProfile.profilePhotoURL)
        print(userProfile.emailAddress)
        print(userProfile.fullName)
        
    }
    
    func getPhoto(dispatch: DispatchGroup){
        let storage = Storage.storage()
        let imagesRef = storage.reference().child("profilephotos/\(Auth.auth().currentUser!.uid)")
        DispatchQueue.main.async {
            imagesRef.getData(maxSize: 2 * 2048 * 2048) { data, error in
                if let error = error {
                    // Uh-oh, an error occurred!
                    userProfile.profilePhoto = UIImage(imageLiteralResourceName: "profile_photo_edit")
                    print(error.localizedDescription)
                } else {
                    // Data for "profilephotos/\(uid).jpg" is returned
                    // print("data: \(data)")
                    userProfile.profilePhoto = UIImage(data: data!)!
                    }
                print("leave")
                dispatch.leave()
            }
        }
    }
    
    func logginFb() {
        socialLogin.attemptLoginFb(completion: { result, error in
            if(error == nil){
                print("made it")
                let d = DispatchGroup()
                d.enter()
                self.updateProfile(dispatch: d)
                d.notify(queue: .main){
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NoMoreOnboard"), object: nil)
                }
            }else{
                //create alert saying no account associated with this FB profile. Please use sign up page
                //make case for the error that comes when above happens
                self.alertMessage = "No account associated with this Facebook profile. Please create a new account."
                self.alertTitle = "Error!"
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
        
        func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
            return UIView()
        }
        
        func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
        }
        
        func attemptLoginGoogle() {
            login = true
            signUp = false
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
            GIDSignIn.sharedInstance()?.signIn()
            
        }
        
        func attemptLoginFb(completion: @escaping (_ result: LoginManagerLoginResult?, _ error: Error?) -> Void) {
            let dispatch = DispatchGroup()
            let fbLoginManager: LoginManager = LoginManager()
            fbLoginManager.logOut()
            print("logged out")
            
            fbLoginManager.logIn(permissions: ["email"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
                // print("RESULT: '\(result)' ")

                if error != nil {
                    print("error")
                    return
                }else if(result!.isCancelled){
                    print("result cancelled")
                    return
                }
                
                if(!result!.isCancelled){
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        //authresult = Promise of UserCredential
                        //print("signing in")
                        if(authResult != nil){
                            //print("authorized")
                            //print(authResult?.additionalUserInfo?.profile)
                            let userInfo = authResult?.additionalUserInfo?.profile
                            if let userInfo = userInfo,
                                                       let email: String = userInfo["email"] as? String,
                                                       let name: String = userInfo["name"] as? String,
                                                       let picture = userInfo["picture"] as? [String: Any],
                                                       let data = picture["data"] as? [String: Any],
                                let url = data["url"] as? String {
                                    userProfile.fullName = name
                                    userProfile.emailAddress = email
                                    userProfile.profilePhotoURL = url
                                    print(userProfile.emailAddress)
                                    print(userProfile.fullName)
                                    dispatch.enter()
                                    userProfile.userId = Auth.auth().currentUser!.uid
                                    dispatch.notify(queue: .main) {
                                        dispatch.enter()
//                                        userProfile.getProfilePhoto(dispatch: dispatch)
                                        dispatch.notify(queue: .main){
                                            completion(result, error)
                                            return
                                        }
                                    }
                            }
                            //need to check if user exists with password, if so, then get pic
                            Auth.auth().fetchSignInMethods(forEmail: userProfile.emailAddress)
//                            { (methods, error) in
//                                print(error)
//                                if(methods!.count > 1){
//                                    dispatch.enter()
////                                    userProfile.getProfilePhoto(dispatch: dispatch)
//                                    dispatch.notify(queue: .main){
//                                        completion(result, error)
//                                        return
//                                    }
//                                }
//                                }
                                completion(result, error)
                                return
                        }
                        else{
                            //no account exists with this FB profile -> alert saying "please go to sign up"
                            print("no account exists")
                            print(error.debugDescription)
                            completion(result, error)
                            return
                        }
                    }
                }
            }
        }
    }
    
}
