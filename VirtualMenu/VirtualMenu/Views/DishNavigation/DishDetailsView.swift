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
    
    @EnvironmentObject var order : OrderModel
    
    let dispatchG1 = DispatchGroup()

    @State var reviewClicked = false
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    
    //fetch reviews of dish on appear and have "Reviews" button pass info to new view of entire scroll view of it
    
    var body: some View {
        ZStack{
        VStack(alignment: .center) {
            Spacer().frame(width: UIScreen.main.bounds.width, height: -60)
            VStack(spacing: 20){
                Text("\(dish.name)")
                    .font(.title)
                    .font(.custom("Open Sans", size: 32))
                FBURLImage(url: dish.coverPhotoURL, imageAspectRatio: .fill, imageWidth: 300, imageHeight: 180, owndimen: true)
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
                    if(!self.order.checkSameRest(dish: self.dish)){
                        self.alertTitle = "Different Restaurant"
                        self.alertMessage = "A new order has been started for \(self.restaurant.name)"
                        self.showingAlert.toggle()
                        self.order.newOrder(rest: self.restaurant)
                    }else{
                        self.alertTitle = "Dish Added"
                        self.alertMessage = "A new dish has been added to your order. Check the order tab to see your entire order."
                        self.showingAlert.toggle()
                    }
                    self.dispatchG1.enter()
                    self.order.restChosen = self.restaurant
                    self.order.addDish(dish: self.dish, rest: self.restaurant, dis: self.dispatchG1)
                    self.dispatchG1.notify(queue: .main){
//                        print("\(self.order.dishRestaurant[self.dish])")
                    }
                }
                .alert(isPresented: self.$showingAlert) {
                    Alert(title: Text("\(self.alertTitle)"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                }
                NavigationLink(destination: DishReviewsView(isPresented: .constant(true), dish: self.dish, restaurant: self.restaurant)){
                    ReviewsButton()
                }
            }
            .padding()
        }
        }.background(GradientView().edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: WhiteBackButton(mode: self.mode))
    }
}

struct DishDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DishDetailsView(dish: DishFB.previewDish(), restaurant: RestaurantFB.previewRest())
    }
}
