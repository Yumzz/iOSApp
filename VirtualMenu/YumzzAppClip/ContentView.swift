//
//  ContentView.swift
//  YumzzAppClip
//
//  Created by William Bai on 9/28/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var restaurant: RestaurantFB?
    
    init() {
        let db = Firestore.firestore()
        let restaurantRef = db.collection("Restaurant").document("8mErR4vH8qjBBpb8sttN")
        var rest: RestaurantFB? = nil
        restaurantRef.getDocument { (document, error) in
            if let document = document, document.exists {
                rest = RestaurantFB(snapshot: document)!
            } else {
                print(error?.localizedDescription ?? "asdf")
            }
        }
        self.restaurant = rest
    }
    
    var body: some View {
        if self.restaurant == nil {
            EmptyView()
        } else {
            RestaurantHomeView(restaurant: self.restaurant!, distance: 10)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
