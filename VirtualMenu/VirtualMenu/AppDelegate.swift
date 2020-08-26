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
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var user =  UserStore()
    var dispatch = DispatchGroup()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
                
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        return true
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        if let fbSDKAppId = Settings.appID, url.scheme!.hasPrefix("fb\(fbSDKAppId)"), url.host == "authorize" {
            print("facebook login")
            let shouldOpen :Bool = ApplicationDelegate.shared.application(
                application,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
        return shouldOpen
        }
        
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // Google sign in and token retrieval
        let authen = AuthenticationViewModel()
        if(user == nil){
            return
        }
          
        if error != nil {
    //        print("Error:\(error)")
            return
          }
        
        let fullName: String = user.profile.name
        let email: String = user.profile.email
        
        guard let authentication = user.authentication else { return }
        
          //Google Credential -> Firebase credential
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
          
          //sign up has different method called in AppDelegate
        var noUser = false
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if(error != nil){
                noUser = true
            }
        }
        
        print("SignUp: \(signUp)")
        if(signUp){
            //if user not found + signup then create new user w temp password and send password reset link
            if(noUser){
                print("signup")
                let x = user.hashValue
                print(x)
                self.dispatch.enter()
                Auth.auth().createUser(withEmail: email, password: String(x)) { (authResult, error) in
                    if(error != nil){
                        NSLog(String(error!.localizedDescription))
                    }
                    else{
                        print("created user")
                    }
                    self.dispatch.leave()
                }
                dispatch.notify(queue: .main){
                    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                        if error != nil{
                            NSLog(String(error!.localizedDescription))
                            return
                        }
                        else{
                            print("sent password reset")
                        }
                    }
                    signUp = false
                    self.user.isLogged = true
                    self.user.showOnboarding = false
                }
            }else{
                print("user already exists")
            }
        }
        if(login){
            Auth.auth().signIn(with: credential) { (authResult, error) in
                //authresult = Promise of UserCredential
                if(authResult != nil){
                    if(login){
                        userProfile.emailAddress = email
                        userProfile.fullName = fullName
                        print(userProfile.emailAddress)
                        print(userProfile.fullName)
                        self.dispatch.enter()
                        authen.fetchUserID(name: fullName, email: email, dispatch: self.dispatch)
                        self.dispatch.notify(queue: .main) {
                            self.dispatch.enter()
                            userProfile.getProfilePhoto(dispatch: self.dispatch)
                            self.dispatch.notify(queue: .main){
                                print("done with photo getting")
                                login = false
                                return
                            }
                        }
                    }
                }
                print(error.debugDescription)
                return
               
            }
            self.user.isLogged = true
            self.user.showOnboarding = false
        }
        
          
          //try to sign in
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//        print("app del here")
//        let authen = AuthenticationViewModel()
//
//        if(!result!.isCancelled){
//            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
//
//            Auth.auth().signIn(with: credential) { (authResult, error) in
//                //authresult = Promise of UserCredential
//                if(authResult != nil){
//                    userProfile.emailAddress = Auth.auth().currentUser?.email! as! String
//                    userProfile.fullName = Auth.auth().currentUser?.displayName! as! String
//                    print(userProfile.emailAddress)
//                    print(userProfile.fullName)
//                    self.dispatch.enter()
//                    authen.fetchUserID(name: userProfile.fullName, email: userProfile.emailAddress, dispatch: self.dispatch)
//                    self.dispatch.notify(queue: .main) {
//                        userProfile.getProfilePhoto()
//                        self.user.showOnboarding = false
//                        return
//                    }
//                }
//            }
//        }
//    }
    
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        print("log out")
//    }
    
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

