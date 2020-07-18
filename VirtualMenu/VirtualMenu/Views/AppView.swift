//
//  AppView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 04/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct AppView: View {
    
//    @State private var currentTab = 1
    
    var body: some View {
        TabView() {
            NavigationView {
                SearchView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            
            NavigationView {
                OrderView()
            }
            .tabItem {
                Image(systemName: "square.and.pencil")
                Text("Order")
            }
            
            NavigationView {
                FavoriteView()
            }
            .tabItem {
                Image(systemName: "star")
                Text("Favorites")
            }
            
            NavigationView {
                AccountProfileView()
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Account")
            }
            
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        
        AppView()
    }
}
