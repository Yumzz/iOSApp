//
//  OrderView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 04/07/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct OrderView: View {
    
    @State private var selectorIndex = 0
    @State private var numbers = ["Current Selection","Past Orders"]
    
    @ObservedObject var orderViewModel = OrderViewModel()
    @ObservedObject var restViewModel = RestaurantDishViewModel()
    
    var body: some View {
        VStack() {
            //If Current Selection, show what is added to cart so far
            Picker("Numbers", selection: self.$selectorIndex) {
                ForEach(0 ..< self.numbers.count) { index in
                    Text(self.numbers[index]).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(maxWidth: .infinity)
            .padding()
            
            Spacer()
            
            Text("See: \(self.numbers[self.selectorIndex])").padding()
            
            if !self.orderViewModel.dishesChosen.isEmpty {
                
                ForEach(self.orderViewModel.dishesChosen, id: \.id) { dish in
                    //need to get restaurantFB in orderViewModel
                    NavigationLink(destination: DishDetailsView(dish: dish, restaurant: self.orderViewModel.dishRestaurant[dish]!)){
                        VStack {
                            OrderCard(urlImage: FBURLImage(url: dish.coverPhotoURL),dish: dish)
                            //have star rating of dish on it
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }

            
            Spacer()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("My Orders")
            .onAppear {
                print("\(self.orderViewModel.dishesChosen)")
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderView()
        }
        
    }
}
