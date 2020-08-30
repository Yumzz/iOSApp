//
//  DishDetailsView.swift
//  VirtualMenu
//
//  Created by William Bai on 6/18/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct ReviewUser: Identifiable {
    let id = UUID()
    let review: Review
    let user: UserProfile
}

struct DishDetailsView: View {
    
    let dish: DishFB
    
    let restaurant: RestaurantFB
    
    @ObservedObject var restDishVM = RestaurantDishViewModel()
    
    @EnvironmentObject var order : Order
    
    let dispatchG1 = DispatchGroup()

    @State var reviewClicked = false
    
    //fetch reviews of dish on appear and have "Reviews" button pass info to new view of entire scroll view of it
    
    var body: some View {
        VStack(alignment: .center) {
            VStack{
                Text("\(dish.name)")
                    .font(.title)
                FBURLImage(url: dish.coverPhotoURL)
                    .frame(width: 330, height: 210)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                
                Text("Price: " + DishFB.formatPrice(price: dish.price))
                    .foregroundColor(.secondary)
                    .font(.headline)
                Text(dish.description)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 0)
                OrderButton().onTapGesture {
                    //send info to POS
                    print("order tapped")
                    self.dispatchG1.enter()
                    print("add dish to list")
                    self.order.addDish(dish: self.dish, rest: self.restaurant, dis: self.dispatchG1)
                    self.dispatchG1.notify(queue: .main){
                        print("\(self.order.dishRestaurant[self.dish])")
                    }
                }
                ReviewsButton().onTapGesture {
                    //go to reviews view
                    self.reviewClicked = true
                }
                
            }.sheet(isPresented: self.$reviewClicked){
                DishReviewsView(dish: self.dish, restaurant: self.restaurant)
            }
            .padding()
        }
    }
}

struct DishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DishDetailsView(dish: .init(name: "Dish", description: "Description", price: 25, type: "Type", restaurant: "Restaurant"), restaurant: .init(name: "Restaurant", description: "Description", averagePrice: 10, type: "Type", ethnicity: "Ethnicity", dishes: [], coordinate: .init(latitude: 10, longitude: 10), address: "Address", phone: "Phone", price: "Price"))
    }
}
