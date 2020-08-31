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
    
    @EnvironmentObject var order : OrderModel
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
            
//            How to switch between current selection and past orders
            if selectorIndex == 0 {
                if !self.order.dishesChosen.isEmpty {
                    List{
                        ForEach(self.order.dishesChosen, id: \.id) { dish in
                            //need to get restaurantFB in orderViewModel
                            NavigationLink(destination: DishDetailsView(dish: dish, restaurant: self.order.dishRestaurant[dish]!)){
                                VStack {
                                    OrderCard(urlImage: FBURLImage(url: dish.coverPhotoURL),dish: dish)
                                    //have star rating of dish on it
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    Text("Subtotal: \(self.order.totalCost)")
                
                }
                else{
                    Text("Go add some dishes to your order!")
                }
            }
            else{
                //past orders
            }
            
            Spacer()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("My Orders")
            .onAppear {
                print("\(self.order.dishesChosen)")
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
