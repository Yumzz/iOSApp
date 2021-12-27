//
//  SceneDelegate.swift
//  YumzzAppClip
//
//  Created by Rohan Tyagi on 12/21/21.
//  Copyright © 2021 Rohan Tyagi. All rights reserved.
//

import SwiftUI
//import Firebase

struct ContentView: View {
    @State var rest: RestaurantFB = RestaurantFB.previewRest()
    @ObservedObject var viewModel : ContentViewModel
    
    let dispatchGroup = DispatchGroup()
    
    init(id: String){
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
        .onAppear{
            self.dispatchGroup.notify(queue: .main){
                print("appear")
                self.rest = self.viewModel.restaurant!
                print(self.rest.hour == "")
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
