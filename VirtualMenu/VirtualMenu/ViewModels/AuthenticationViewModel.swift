//  AuthenticationViewModel.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/27/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FBSDKLoginKit

var userProfile: UserProfile = UserProfile(userId: "", fullName: "", emailAddress: "", profilePicture: "", profPhoto: nil)


class AuthenticationViewModel: ObservableObject {
    
    @State var sign = false
    let dispatchGroup = DispatchGroup()

        
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
    
    func signIn(email: String, password: String) -> Bool{
        var bool = true
        Auth.auth().signIn(withEmail: email, password: password){
            (result, error) in
            if(error == nil){
                self.sign = true
                print(self.sign)
                self.updateProfile()
            }
            else{
                bool = false
                print("failed")
            }
        }
        print(sign)
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
    
    func updateProfile() {
        let storage = Storage.storage()
        let imagesRef = storage.reference().child("profilephotos/\(Auth.auth().currentUser!.uid)")
        
        print(imagesRef.storage)
        print(imagesRef.bucket)
        print(imagesRef.name)
        
        Utils().getUserProfileImgURL(userId: Auth.auth().currentUser!.uid, completionHandler: { (res) in
            userProfile.profilePhotoURL = res
        })
        
        userProfile.userId = Auth.auth().currentUser!.uid
        userProfile.emailAddress = Auth.auth().currentUser!.email!


        let fb = Firestore.firestore()
        let ref = fb.collection("User")
        
        let query = ref.whereField("id", isEqualTo: userProfile.userId).whereField("email", isEqualTo: userProfile.emailAddress)
                        
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
                    print("data: \(data)")
                    userProfile.profilePhoto = UIImage(data: data!)!
                }
            }
        }
        //        DispatchQueue.main.async {
        //        }
        print(userProfile.profilePhotoURL)
        print(userProfile.emailAddress)
        print(userProfile.fullName)
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
    
    struct SocialLogin: UIViewRepresentable {
        
        func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
            return UIView()
        }
        
        func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
        }
        
        func attemptLoginGoogle() {
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
            GIDSignIn.sharedInstance()?.signIn()
        }
        
        func attemptLoginFb(completion: @escaping (_ result: LoginManagerLoginResult?, _ error: Error?) -> Void) {
            let fbLoginManager: LoginManager = LoginManager()
            fbLoginManager.logOut()
            fbLoginManager.logIn(permissions: ["email", "name", "public_profile"], from: UIApplication.shared.windows.last?.rootViewController) { (result, error) -> Void in
                completion(result, error)
            }
        }
    }
    
    
}
