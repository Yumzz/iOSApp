//
//  ContentView.swift
//  YumzzAppClip
//
//  Created by William Bai on 9/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
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
//        self.dispatchGroup.notify(queue:.main){
//            print("done")
////            self.saveRest(rest: self.viewModel.restaurant!)
//       }
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
//        if self.restaurant == nil {
                
//        } else {
//        ListDishesView(restaurant: self.viewModel.restaurant)
        
            //having trouble with listdishesview w some sections
//            ListDishesView(restaurant: self.restaurant!)
//            RestaurantHomeView(restaurant: self.restaurant!, distance: 10)
//        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(id: "")
    }
}
