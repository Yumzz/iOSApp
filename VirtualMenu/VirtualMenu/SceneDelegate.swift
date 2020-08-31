//
//  SceneDelegate.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 5/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import UIKit
import SwiftUI
import FBSDKCoreKit
import Firebase


class AccountDetails: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var count: Int = 0
    @Published var loggedIn: Bool = false
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var user =  UserStore()
    var window: UIWindow?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        var google = false
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let urlToOpen = userActivity.webpageURL
            else {
                return
        }
        
//        print(userActivity.webpageURL?.)

        print(handlePasswordlessSignIn(withURL: urlToOpen, facebook: facebook, google: google))
    }
    
    func handlePasswordlessSignIn(withURL: URL, facebook: Bool, google: Bool) -> Bool{
        print("here")
        
        let link = withURL.absoluteString
        if(!facebook && !google){
            print("facebook: \(facebook)")
            print("google: \(google)")
            if(Auth.auth().isSignIn(withEmailLink: link)){
                    print("is link")
                    guard let email = UserDefaults.standard.value(forKey: "Email") as? String else { return false}
                    guard let password = UserDefaults.standard.value(forKey: "Password") as? String else { return false}
                    guard let name = UserDefaults.standard.value(forKey: "Name") as? String else { return false}
                    
                    var disp = DispatchGroup()
                    disp.enter()
                    Auth.auth().signIn(withEmail: email, link: link) { (dataResult, error) in
                        if let error = error {
                            print("Error \(error.localizedDescription)")
                            //show alert to user
                            return
                        }
                        else{
                            guard let result = dataResult else{
                                return
                            }
                            userProfile.emailAddress = email
                            userProfile.fullName = name
                            userProfile.userId = Auth.auth().currentUser!.uid
                            
        //                    userProfile.profilePhotoURL = result.user.photoURL!.absoluteString
                            print("UserProfile: \(userProfile.userId)")
                            disp.leave()
                        }
                    }
                    disp.notify(queue: .main){
                        let data = [
                                "uid" : userProfile.userId,
                                 "email" : email,
                                 "password": password,
                                 "username" : name
                                 ] as [String : Any]

                            Firestore.firestore().collection("User").addDocument(data: data, completion: {
                                (err) in
                                if let err = err {
                                    //show alert to user
                                    print(err.localizedDescription)
                                    return
                                }
                                print("added doc")
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "NoMoreOnboard"), object: nil)
                //                show success alert
                            })
                    }
                    return true

                }
        }
        else if (facebook || google){
            //facebook - email sign in and link credential
            print("fb or google in")
            if(Auth.auth().isSignIn(withEmailLink: link)){
                guard let email = UserDefaults.standard.value(forKey: "Email") as? String else { return false}
                
//                guard let name = UserDefaults.standard.value(forKey: "Name") as? String else { return false}
                
                var disp = DispatchGroup()
                
                disp.enter()
                Auth.auth().signIn(withEmail: email, link: link) { (dataResult, error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                        //show alert to user
                        return
                    }
                    else{
                        guard let result = dataResult else{
                            return
                        }
                        userProfile.emailAddress = email
//                        userProfile.fullName = name
                        userProfile.userId = Auth.auth().currentUser!.uid
                        Auth.auth().currentUser?.link(with: credential!, completion: { (res, err) in
                            if let err = err {
                                print(err.localizedDescription)
                            }
                            print("credential: \(credential.debugDescription)")
                        })
                        disp.leave()
                        disp.notify(queue: .main){
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "NoMoreOnboard"), object: nil)
                        }
                    }
                }
                
            }
        }
        
        return false
    }
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        
        //This commented code allows us to be signed out everytime so we can test easier
        //UserDefaults.standard.set("", forKey: signInWithAppleManager.userIdentifierKey)
        
        let contentView = ContentView()
        var order = OrderModel()
        var user = UserStore()
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView.environmentObject(user)
                .environmentObject(order))
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

