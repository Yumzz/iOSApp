//
//  RestaurantSearchListView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 16/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct Resto: Identifiable {
    var id: Int
    
    let image: Image?
    
    let name: String
    let address: String
    let score: Float
    let nbOfRatings: Int
}


struct RestaurantSearchListView: View {
    
    @ObservedObject var restDishVM = RestaurantDishViewModel()
    
    @State var restaurants: [RestaurantFB] = [RestaurantFB]()
    
    @Binding var isNavigationBarHidden: Bool
    
    var types: [String] = ["Asian, Mexican, Italian"]
    
    var restos: [Resto] = [
        Resto.init(id: 0, image: nil, name: "Oishii Bowl", address: "113 Dryden Rd, Ithaca", score: 4.9, nbOfRatings: 120),
        
        Resto.init(id: 1, image: nil, name: "Plum Tree", address: "113 Dryden Rd, Ithaca", score: 4.9, nbOfRatings: 120),
        
        Resto.init(id: 2, image: nil, name: "CTB", address: "113 Dryden Rd, Ithaca", score: 4.9, nbOfRatings: 120),
        
        Resto.init(id: 3, image: nil, name: "Gangnam Station", address: "113 Dryden Rd, Ithaca", score: 4.9, nbOfRatings: 120),
        
        Resto.init(id: 2, image: nil, name: "CTB", address: "113 Dryden Rd, Ithaca", score: 4.9, nbOfRatings: 120),
        
        Resto.init(id: 3, image: nil, name: "Gangnam Station", address: "113 Dryden Rd, Ithaca", score: 4.9, nbOfRatings: 120)
    ]
    
    var body: some View {
        
        ScrollView {
            Text("10 Places")
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            VStack(spacing: 20){
            
            //            VStack{
            //                //Type of Restaurant
            //                ZStack{
            //                    Image("")
            //                    .resizable()
            //                    .aspectRatio(contentMode: .fill)
            //                    .overlay(Color(UIColor().colorFromHex("#F88379", 0.5)))
            //                    .edgesIgnoringSafeArea(.all)
            //
            //                    Text("Dots signifying swipability")
            //                }
            //            }
            
            
            
                ForEach(restos, id: \.id) { resto in
                    Button(action: {
                        
                    }){
                        DishCard(image: resto.image, restaurantName: resto.name, restaurantAddress: resto.address,score: resto.score, nbOfRatings: resto.nbOfRatings)
                    }
                        
                    
                    
                }
                
                Spacer()
                    .frame(height: 30)
            
            //Type of Restaurant
            //swipe to each theme
            //have collection view for each type and make them scrollable
        }
        
            
        }
        .navigationBarTitle("Asian Restaurants")
        .onAppear(){
            self.restaurants = self.restDishVM.allRests
            self.isNavigationBarHidden = false
        }
    }
}

struct RestaurantSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantSearchListView( isNavigationBarHidden: .constant(false))
        }
    }
}

