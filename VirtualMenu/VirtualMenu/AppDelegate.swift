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
import FirebaseFirestoreSwift
//import FirebaseDynamicLinks

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
//        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url){
//            print("here instade")
//            self.handlePasswordlessSignIn(withURL: dynamicLink.url!)
//            return true
//        }
        
        return GIDSignIn.sharedInstance().handle(url)
        
    }
    
    // MARK: UISceneSession Lifecycle
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // Google sign in and token retrieval
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
        credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
          
//        var noUser = false
//        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
//            if(error != nil){
//                noUser = true
//            }
//        }
        google = true
        facebook = false
        
        print("google: \(credential.debugDescription)")
        if(signUp){
            //send confirmation email, go to app and link account with credential, save user info, and transition
//            if(noUser){
            //need to check if account already exists with this email
            let actionCode = ActionCodeSettings()
            actionCode.url = URL(string: "https://yumzzapp.page.link/connect")
            actionCode.handleCodeInApp = true
            actionCode.setIOSBundleID(Bundle.main.bundleIdentifier!)
            self.dispatch.enter()
            print(email)
            Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCode) { (error) in
//                            self.user.showOnboarding = false
                if error != nil {
                  return
                }
                UserDefaults.standard.set(email, forKey: "Email")
                UserDefaults.standard.set(fullName, forKey: "Name")
                userProfile.emailAddress = email
                userProfile.fullName = fullName
                self.dispatch.leave()
            }
            self.dispatch.notify(queue: .main){
                facebook = false
                google = true
                signUp = false
                return
            }
        }
        if(login){
            print("login")
            google = true
            facebook = false
            Auth.auth().signIn(with: credential!) { (authResult, error) in
                //authresult = Promise of UserCredential
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if(authResult != nil){
                    userProfile.emailAddress = email
                    userProfile.fullName = fullName
                    userProfile.userId = Auth.auth().currentUser!.uid
//                    Auth.auth().fetchSignInMethods(forEmail: userProfile.emailAddress) { (methods, error) in
//                        if(methods!.count > 1){
                    self.dispatch.enter()
                    userProfile.getProfilePhoto(dispatch: self.dispatch)
                    self.dispatch.notify(queue: .main){
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "NoMoreOnboard"), object: nil)
                    return
                            }
//                        }
//                    }
                }
                return
               
            }
        }
        
    }
    
    
    

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        print("here")
        return false
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        let firebaseAuth = Auth.auth()
        do {
              try firebaseAuth.signOut()
        
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
        self.user.isLogged = false
        self.user.showOnboarding = true
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
        NSLog("did it")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NSLog("did it")
        let firebaseAuth = Auth.auth()
            do {
                defer {
                    userProfile = UserProfile(userId: "", fullName: "", emailAddress: "", profilePicture: "", profPhoto: nil)
                    NSLog(userProfile.emailAddress)
                    self.user.isLogged = false
                    self.user.showOnboarding = true
                    NSLog("done")

                }
              try firebaseAuth.signOut()
        
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }

    }


}

