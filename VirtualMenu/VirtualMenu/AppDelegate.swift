//
//  AppDelegate.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
//        let fr = FirebaseRequest()
//        print("Firebase connection established")
//        print(fr.fetchAllDishes())
        return true
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

//    func signUp(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?){
//
//        if (error != nil) {
//            if ((error as! NSError).code == -4) {
//            NSLog("The user has not signed in before or they have since signed out.")
//          } else {
//            NSLog(String(error!.localizedDescription))
//          }
//          return
//        }
//
//
//        let userId: String = user.userID
//        let idToken: String = user.authentication.idToken
//        let fullName: String = user.profile.name
//        let givenName: String = user.profile.givenName
//        let familyName: String = user.profile.familyName
//        let email: String = user.profile.email
//        // ...
        
        
        
//        guard let authentication = user.authentication else { return []}
//
//
//
//        //Google Credential -> Firebase credential
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                          accessToken: authentication.accessToken)
        
        
            
//        }
        

func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // Google sign in and token retrieval
    
    if(user == nil){
        return
    }
      
    if error != nil {
        print("Error:\(error)")
        return
      }
    
    
 
    let userId: String = user.userID
    let fullName: String = user.profile.name
    let email: String = user.profile.email
    
    guard let authentication = user.authentication else { return }
        
      //Google Credential -> Firebase credential
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
      
      //sign up has different method called in AppDelegate
      
      //try to sign in
    Auth.auth().signIn(with: credential) { (authResult, error) in
        //authresult = Promise of UserCredential
    if(authResult != nil){
        userProfile.emailAddress = email
        userProfile.fullName = fullName
        userProfile.userId = userId
        userProfile.profilePhoto = userProfile.getProfilePhoto()
        print(userProfile.profilePhoto?.description)
        return
    }
    //if user not found then create new user w temp password and send password reset link
    var a = false
    Auth.auth().fetchSignInMethods(forEmail: email, completion: { (emailProm, error) in
        if(error != nil){
            a = true
        }
    })
    
    if (error != nil){
        if(a){
            let x = user.hashValue
            Auth.auth().createUser(withEmail: email, password: String(x)) { (authResult, error) in
                if(error != nil){
                    NSLog(String(error!.localizedDescription))
                }
            }
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error != nil{
                    NSLog(String(error!.localizedDescription))
                }
            }
        }
        NSLog(String(error!.localizedDescription))
        return
    }

    }
}
    
    

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

