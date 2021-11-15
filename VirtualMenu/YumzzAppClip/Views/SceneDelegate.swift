//
//  SceneDelegate.swift
//  YumzzAppClip
//
//  Created by William Bai on 9/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    @State private var idstring : String = ""


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(id: "a1Lwu7xEFrhDh9wnVpCP")
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb){ userActivity in
                guard let incomingURL = userActivity.webpageURL,
                      let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
                      let _ = components.queryItems
                else{
                    return
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AppClipRest"), object: incomingURL)
            }
//        let contentView = ContentView(id: idstring)
//            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb){ userActivity in
//                guard let incomingURL = userActivity.webpageURL,
//                      let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
//                      let _ = components.queryItems
//                else{
//                    return
//                }
////                let restId = components.queryItems?.first(where: { $0.name == "restaurant" })?.value!
////                self.idstring = restId!
////                print("idstring: \()")
//                switch components.path {
//                        case "/restaurant":
//                            if let queryItems = components.queryItems,
//                               let restId = queryItems.first(where: { $0.name == "id" })?.value {
//            //    /restaurant?id={id}
//            //                    let dispatchGroup = DispatchGroup()
//        //                        type(of: self).init(id: restId)
////                                print("id: \(self.idstring)")
//                                self.idstring = restId
////                                print("id1: \(self.idstring)")
//                            }
//                        default:
//                            break
//                    }
//
//            }
        let order = OrderModel()
//        let user = UserStore()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let navigation = Navigation(window: window)
            window.rootViewController = UIHostingController(rootView: contentView.environmentObject(order).environmentObject(navigation))
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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

