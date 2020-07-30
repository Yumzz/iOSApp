//
//  RestaurantSearchListView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 16/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct RestaurantSearchListView: View {
    
    @ObservedObject var restDishVM = RestaurantDishViewModel()
    @State var restaurants: [RestaurantFB] = [RestaurantFB]()
    
    var types: [String] = ["Asian, Mexican, Italian"]
        
    var body: some View {
        
        VStack{
            VStack{
                //Type of Restaurant
                ZStack{
                    Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(Color(UIColor().colorFromHex("#F88379", 0.5)))
                    .edgesIgnoringSafeArea(.all)
                    
                    Text("")
                }
            }
            
            Text("Number of Restaurants in this category")
            
//            List {
//
//            }
            
            //Type of Restaurant
            //
            //number of places
            //list card view
            //swipe to each theme
            //have collection view for each type and make them scrollable
            
        }.onAppear(){
            //
            self.restaurants = self.restDishVM.allRests
        }
    }
}

struct RestaurantSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantSearchListView()
    }
}
 
