//
//  ListDishesView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 10/06/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import Firebase

struct ListDishesView: View {
        
    var restaurant: RestaurantFB
    
    @ObservedObject var listDishVM: ListDishesViewModel
        
    @State var dishesDisplayed: [DishFB] = []
    
    @State var isLoading = false
    
    @State var dishCategoriesDisplayed: [DishCategory] = []
    
    @State var allClicked = false
    
    
    init(restaurant: RestaurantFB) {
        
        self.restaurant = restaurant
        
        self.listDishVM = ListDishesViewModel(restaurant: self.restaurant)
                
//        print("categories: \(self.dishCategoriesVM.dishCategories)")
                
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
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
                                    self.dishCategoriesDisplayed = []
                                    self.allClicked = false
                                }
                                else{
                                    self.dishCategoriesDisplayed = self.listDishVM.dishCategories
                                    self.allClicked = true
                                }
                            }
                            ForEach(self.listDishVM.dishCategories, id: \.name){ dishCategory in
                                Text("\(dishCategory.name)")
                                    .padding()
                                    .scaledToFit()
                                    .background(
                                       Color(UIColor().colorFromHex("#F88379", 1)
                                       ))
                                    .foregroundColor(self.dishCategoriesDisplayed.contains(dishCategory) ? Color.white : Color.black)
                                    .cornerRadius(5)
                                    .onTapGesture {
                                        if(self.allClicked){
                                            self.dishCategoriesDisplayed.removeAll()
                                            self.dishCategoriesDisplayed.append(dishCategory)
                                            self.allClicked = false
                                        }else{
                                        if(self.dishCategoriesDisplayed.contains(dishCategory)){
                                                if let index = self.dishCategoriesDisplayed.firstIndex(of: dishCategory) {
                                                        self.dishCategoriesDisplayed.remove(at: index)
                                                    }
                                        }else{
                                            self.dishCategoriesDisplayed.append(dishCategory)
                                        }
                                    }
                                }
                                    
                            }
                        }

                    }
                    
                    Spacer().frame(height: 20)
                    
                    ForEach(self.dishCategoriesDisplayed, id: \.name){ dishCategory in
                        VStack(alignment: .leading, spacing: 40) {
                            
                            Text("\(dishCategory.name)")
                                .font(.title)
                                .fontWeight(.semibold)
                                .padding(.leading)
                            
                            VStack(spacing: 20){
                                
                                ForEach(dishCategory.dishes, id: \.id) {
                                    dish in
                                    NavigationLink(destination:
                                        DishDetailsView(dish: dish, restaurant: self.restaurant).navigationBarHidden(false)
                                    ) {
                                        DishCard(urlImage: FBURLImage(url: dish.coverPhotoURL, imageAspectRatio: .fill), dishName: dish.name, dishIngredients: dish.description, price: self.listDishVM.formatPrice(price: dish.price))
                                    }
                                }
                                Spacer().frame(height: 20)
                            }
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            
        }.onAppear{
            self.allClicked = true
                        
            self.dishCategoriesDisplayed = self.listDishVM.dishCategories
        }
        .navigationBarTitle("Dishes")
    }
}


struct ListDishesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ListDishesView(restaurant:  RestaurantFB.previewRest())
        }
        
    }
}
