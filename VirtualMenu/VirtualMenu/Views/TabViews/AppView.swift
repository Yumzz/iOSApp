//
//  AppView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 04/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
    @State private var currentTab = 1
    
    var body: some View {
        TabView(selection: $currentTab) {
            NavigationView {
                RestaurantMapView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }.tag(1)

            
            NavigationView {
                OrderView()
            }
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Order")
            }.tag(2)

            
//            NavigationView {
//                FavoriteView()
//                .navigationBarTitle("Favorites")
//            }
//            .tabItem {
//                Image(systemName: "star")
//                Text("Favorites")
//            }.tag(3)

            
            NavigationView {
                AccountProfileView()
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Account")
            }.tag(3)


        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
