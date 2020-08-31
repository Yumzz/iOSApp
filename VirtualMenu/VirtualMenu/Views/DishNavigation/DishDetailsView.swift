//
//  DishDetailsView.swift
//  VirtualMenu
//
//  Created by William Bai on 6/18/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

//struct ReviewUser: Identifiable {
//    let id = UUID()
//    let review: Review
//    let user: UserProfile
//}

struct DishDetailsView: View {
    
    let dish: DishFB
    
    let restaurant: RestaurantFB
    
    @ObservedObject var restDishVM = RestaurantDishViewModel()
    
    @EnvironmentObject var order : OrderModel
    
    let dispatchG1 = DispatchGroup()

    @State var reviewClicked = false
            
    var body: some View {
        VStack(alignment: .center) {
            Spacer().frame(width: 0, height: 0)
            VStack(spacing: 20){
                Text("\(dish.name)")
                    .font(.title)
                    .font(.custom("Open Sans", size: 32))
                FBURLImage(url: dish.coverPhotoURL)
                    .frame(width: 330, height: 210)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                Text("Price: " + DishFB.formatPrice(price: dish.price))
                    .foregroundColor(.black)
                    .font(.headline)
                ScrollView{
                    Text(dish.description)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 0)
                }
                DishNavButton(strLabel: "Add to Order").onTapGesture {
                    //send info to POS
                    print("order tapped")
                    self.dispatchG1.enter()
                    print("add dish to list")
                    self.order.addDish(dish: self.dish, rest: self.restaurant, dis: self.dispatchG1)
                    self.dispatchG1.notify(queue: .main){
                        print("\(self.order.dishRestaurant[self.dish])")
                    }
                }
                NavigationLink(destination: DishReviewsView(isPresented: .constant(true), dish: self.dish, restaurant: self.restaurant)){
                    ReviewsButton()
                }
            }
                Spacer()
    }
}
}

struct DishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DishDetailsView(dish: DishFB.previewDish(), restaurant: RestaurantFB.previewRest())
    }
}
