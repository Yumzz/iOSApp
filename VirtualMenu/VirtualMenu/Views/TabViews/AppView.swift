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
                SearchView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }.tag(1)

            
            NavigationView {
                OrderView()
            }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Order")
            }.tag(2)

            
            NavigationView {
                FavoriteView()
            }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            .tabItem {
                Image(systemName: "star")
                Text("Favorites")
            }.tag(3)

            
            NavigationView {
                AccountProfileView()
            }
                .navigationBarTitle("")
                .navigationBarHidden(true)
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Account")
            }.tag(4)


        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}