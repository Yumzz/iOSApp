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
    
    @ObservedObject var restDishVM = RestaurantSearchListViewModel()
    
    @Binding var isNavigationBarHidden: Bool
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 20){
                
                if !self.restDishVM.allRests.isEmpty {
                    
                    if self.restDishVM.allRests.count > 1 {
                        Text("\(String(restDishVM.allRests.count)) Places")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    } else {
                        Text("\(String(restDishVM.allRests.count)) Place")
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                    
                    ForEach(restDishVM.allRests, id: \.id) { resto in
                        
                        NavigationLink(destination: MenuSelectionView(restChosen: resto)){
                            VStack {
                                RestaurantCard(urlImage: FBURLImage(url: resto.coverPhotoURL),restaurantName: resto.name, restaurantAddress: resto.address, ratingSum: resto.ratingSum, nbOfRatings: resto.n_Ratings)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Spacer()
                    .frame(height: 30)
            }
            .padding(.top)
            .frame(maxWidth: .infinity)
        }
        .navigationBarTitle("Asian Restaurants")
        .onAppear(){
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

