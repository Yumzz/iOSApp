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
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    
    init(restaurant: RestaurantFB) {
        
        self.restaurant = restaurant
        
        print("List Dish Vm created")
        self.listDishVM = ListDishesViewModel(restaurant: self.restaurant)
                
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10){
                            Text("View All")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .font(.system(size: 12))
                                .background(self.allClicked ? Color(UIColor().colorFromHex("#707070", 1)) : Color.white)
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
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 12))
                                    .scaledToFit()
                                    .background(self.dishCategoriesDisplayed.contains(dishCategory) ? Color(UIColor().colorFromHex("#707070", 1)) : Color.white)
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

                                        DishCard(urlImage: FBURLImage(url: dish.coverPhotoURL, imageAspectRatio: .fill, imageWidth: 80, imageHeight: 80), dishName: dish.name, dishIngredients: dish.description, price: self.listDishVM.formatPrice(price: dish.price))
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
            print("appear")
            self.dishCategoriesDisplayed = self.listDishVM.dishCategories
            print("show dishcats")
        }
        .background(GradientView().edgesIgnoringSafeArea(.top))
        .navigationBarTitle("Dishes")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: WhiteBackButton(mode: self.mode))
    }
}


struct ListDishesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ListDishesView(restaurant:  RestaurantFB.previewRest())
        }

    }
}
