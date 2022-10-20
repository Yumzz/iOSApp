//
//  YumzzClipApp.swift
//  YumzzClip
//
//  Created by Rohan Tyagi on 12/22/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import Foundation
import SwiftUI

@main
struct YumzzClipApp: App {
//    let window = UIWindow(windowScene: windowScene)
//    let order = OrderModel()
    @State var restname: String = ""
    @State var dishname: String = ""
    @State var id: String = ""
    @State var d: DishFB? = nil
    var body: some Scene {
        WindowGroup {
//            StartView().environmentObject(order)
            ZStack{
//                if(id != ""){
//                ContentView(id: self.id).environmentObject(order)
//                        .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleUserActivity)
//                }
//                if(id != ""){
                ARModelView(id: self.id, dishname: dishname, restname: restname)
//                        .environmentObject(order)
                    .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleUserActivity)
//                    UIARView()
//                    .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleUserActivity)
//                }
            }
//            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleUserActivity)
//            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: handleUserActivity)
        }
    }
    
    func handleUserActivity(_ userActivity: NSUserActivity){
//        print("here")
        guard let incomingURL = userActivity.webpageURL,
              let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
              let queryItems = components.queryItems else
        {
//            print("url: \(userActivity.webpageURL)")
            let url = userActivity.webpageURL!.absoluteString
            print("url: \(url)")
//            self.id = getQueryStringParameter(url: url, param: "id")!
            
//            self.restname = "Vic's All Star Kitchen"
//            self.
            self.restname = getQueryStringParameter(url: url, param: "restname")!
            self.restname = restname.replacingOccurrences(of: "-", with: " ")
            self.dishname = getQueryStringParameter(url: url, param: "dishname")!
            self.dishname = dishname.replacingOccurrences(of: "-", with: " ")
            self.dishname = dishname.replacingOccurrences(of: "'", with: "\"")
            return
        }
        self.id = "a1Lwu7xEFrhDh9wnVpCP"
//        print(self.id)
//        print("handlin user activity")
        let url = userActivity.webpageURL!.absoluteString
        self.id = getQueryStringParameter(url: url, param: "id")!
        self.restname = getQueryStringParameter(url: url, param: "restname")!
        self.restname = restname.replacingOccurrences(of: "-", with: " ")
        self.dishname = getQueryStringParameter(url: url, param: "dishname")!
        self.dishname = dishname.replacingOccurrences(of: "-", with: " ")
        self.dishname = dishname.replacingOccurrences(of: "'", with: "\"")
        // Configure App Clip with query items
    }
    
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
