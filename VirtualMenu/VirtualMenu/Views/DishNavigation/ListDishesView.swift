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
    
    @ObservedObject var restDishVM = RestaurantDishViewModel()
    
    var restaurant: RestaurantFB
    
    @ObservedObject var dishCategoriesVM: DishCategoriesViewModel
    
    @State var dishesDisplayed: [DishFB] = []
    
    @State var isLoading = false
    
    @State var dishCategoriesDisplayed: [DishCategory] = []
    
    
    init(restaurant: RestaurantFB) {
        
        self.restaurant = restaurant
        
        self.dishCategoriesVM = DishCategoriesViewModel(restaurant: self.restaurant)
        
        self.dishCategoriesDisplayed = self.dishCategoriesVM.dishCategories
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Spacer().frame(height: 20)
                    
                    ForEach(self.dishCategoriesVM.dishCategories, id: \.name){ dishCategory in
                        
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
                                        DishCard(urlImage: FBURLImage(url: dish.coverPhotoURL, imageAspectRatio: .fill), dishName: dish.name, dishIngredients: dish.description, price: self.restDishVM.formatPrice(price: dish.price))
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
