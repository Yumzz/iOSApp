//
//  SceneDelegate.swift
//  YumzzAppClip
//
//  Created by Rohan Tyagi on 12/21/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Alamofire
//import Firebase

struct ContentView: View {
    @State var rest: RestaurantFB = RestaurantFB.previewRest()
    @ObservedObject var viewModel : ContentViewModel
    @State var id : String = ""
//    @State var showBanner:Bool = true
//    @State var bannerData: BannerModifier.BannerData = BannerModifier.BannerData(title: "Plant a Tree", detail: "Download the app and sign up, then we will plant a tree in your honor!")
    
    let dispatchGroup = DispatchGroup()
    
    init(id: String){
        self.id = id
        self.viewModel = ContentViewModel(dis: dispatchGroup, id: id)
//        self.viewModel.fetchStuff(dis: dispatchGroup)
    }
    
    
    
    var body: some View {
        ZStack{
            if self.rest.hour == "" {
                Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
            }
            else{
                ListDishesView(restaurant: self.rest)
            }
        }
//        .banner(data: $bannerData, show: $showBanner)
        .onAppear{
            self.dispatchGroup.notify(queue: .main){
                print("appear")
                
//                if(viewModel.restaurant != nil){
                self.rest = self.viewModel.restaurant ?? RestaurantFB.previewRest()
//                }
                var hey = 0
                while(self.rest.name == ""){
                    print("reload bb: \(hey)")
//                    if(hey == 20){
//                        exit(-1)
//                    }
                    var dgroup = DispatchGroup()
                    var viewmo = ContentViewModel(dis: dgroup, id: id)
                    dgroup.notify(queue: .main){
                        
                        self.rest = viewmo.restaurant ?? RestaurantFB.previewRest()
                        print(self.rest.hour == "")
                        hey = hey + 1
                    }
                }
//
                }
            }
        
    }
}

func handleUserActivity(_ userActivity: NSUserActivity){
    
    guard let incomingURL = userActivity.webpageURL,
          let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
          let _ = components.queryItems
    else{
        return
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(id: "")
    }
}
