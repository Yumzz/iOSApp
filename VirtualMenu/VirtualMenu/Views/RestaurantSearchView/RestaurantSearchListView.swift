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
    
    @ObservedObject var restaurantListVM : RestaurantSearchListViewModel
    
    var isNavigationBarHidden: Bool
    
    @State var show = false
    
    @State var restCategoriesDisplayed: [RestCategory] = []
    
    @State var allClicked = false
        
    init(isNavigationBarHidden: Bool){
        self.isNavigationBarHidden = isNavigationBarHidden
        
        self.restaurantListVM = RestaurantSearchListViewModel()
    
    }
    
    
    var body: some View {
        ZStack{
            if self.show{
                GeometryReader{_ in
                    Loader()
                }.background(Color.black.opacity(0.45))
            }
            else{
                ScrollView {
                    VStack(spacing: 20){
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10){
                                Text("View All")
                                    .padding()
                                    .frame(maxWidth: 100)
                                    .background(
                                    Color(UIColor().colorFromHex("#F88379", 1)))
                                    .foregroundColor(self.allClicked ? Color.white : Color.black)
                                .cornerRadius(5)
                                .onTapGesture {
                                    if(self.allClicked){
                                        self.restCategoriesDisplayed = []
                                        self.allClicked = false
                                    }
                                    else{
                                        self.restCategoriesDisplayed = self.restaurantListVM.restCategories
                                        self.allClicked = true
                                    }
                                }
                                ForEach(self.restaurantListVM.restCategories, id: \.name){ restCategory in
                                    Text("\(restCategory.name)")
                                    .padding()
                                    .scaledToFit()
                                    .background(
                                       Color(UIColor().colorFromHex("#F88379", 1)
                                       ))
                                    .foregroundColor(self.restCategoriesDisplayed.contains(restCategory) ? Color.white : Color.black)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        if(self.allClicked){
                                            self.restCategoriesDisplayed.removeAll()
                                            self.restCategoriesDisplayed.append(restCategory)
                                            self.allClicked = false
                                        }else{
                                            if(self.restCategoriesDisplayed.contains(restCategory)){
                                                    if let index = self.restCategoriesDisplayed.firstIndex(of: restCategory) {
                                                            self.restCategoriesDisplayed.remove(at: index)
                                                        }
                                            }else{
                                                self.restCategoriesDisplayed.append(restCategory)
                                            }
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                        
                        ForEach(self.restCategoriesDisplayed, id: \.name){ restCategory in
                            VStack(alignment: .leading, spacing: 40) {
                                
                                Text("\(restCategory.name)")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .padding(.leading)
                                
                                VStack(spacing: 20){
                                    
                                    ForEach(restCategory.restaurants, id: \.id) {
                                        rest in
                                        NavigationLink(destination:
                                            MenuSelectionView(restChosen: rest).navigationBarHidden(false)
                                        ) {
                                            RestaurantCard(restaurantName: rest.name, restaurantAddress: rest.cityAddress, ratingSum: rest.ratingSum, nbOfRatings: rest.n_Ratings)
                                        }
                                    }
                                    Spacer().frame(height: 20)
                                }
                            }
                        }
                    Spacer().frame(height: 30)
                    }
                    .padding(.top)
                    .frame(maxWidth: .infinity)
                }
            }
        }
    .background(GradientView().edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Restaurants")
        .onAppear(){
            
                self.allClicked = true

                self.restCategoriesDisplayed = self.restaurantListVM.restCategories
                
                print(self.restaurantListVM.restCategories)
                
                    
        }
    }
}


struct RestaurantSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantSearchListView(isNavigationBarHidden: false)
        }
    }
}

