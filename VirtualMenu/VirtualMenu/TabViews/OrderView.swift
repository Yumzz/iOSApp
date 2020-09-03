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
    @ObservedObject var restDishVM = RestaurantDishViewModel()

    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        ZStack {
            ScrollView {
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
//            .onReceive([self.selectorIndex].publisher.first()){ (value) in
//                 print(value)
//            }
            
//            How to switch between current selection and past orders
            if selectorIndex == 0 {
                if !self.order.dishesChosen.isEmpty {
                    CompleteOrderCard()
                    SaveOrderButton().onTapGesture {
                        //what do we do here to save orders for user?
                        //have dishes here, need to store into user's orders on FB
                        let ord = Order(dishes: self.order.dishesChosen, totalPrice: self.order.totalCost, rest: self.order.restChosen.name)
                        //put this order onto firebase and add to user's list
                        if(userProfile.userId != ""){
                            self.order.saveOrder(order: ord)
                        }
                        else{
                            self.alertTitle = "Can't Save"
                            self.alertMessage = "You need to have a Yumzz account to save this order for future viewing."
                            self.showingAlert.toggle()
                        }
                        print("save order")
                        
                    }
                    .alert(isPresented: self.$showingAlert) {
                        Alert(title: Text("\(self.alertTitle)"), message: Text("\(self.alertMessage)"), dismissButton: .default(Text("OK")))
                    }
                }
                else{
                    Text("Go add some dishes to your order!")
                }
            }
            else{
                //past orders - fetch based on userID
                //card view for each
                if(self.order.pastOrders.isEmpty){
                    Text("No past orders. Go make one!")
                }
                else{
//                    self.order.retrieveOrders(userID: userProfile.userId)
//                    self.order.pastOrders
                    VStack(spacing: 20){
                        ForEach(self.order.pastOrders, id: \.id) {
                            ord in
                            VStack(alignment: .leading, spacing: 20) {
                                Text("\(ord.rest) Order")
                                .fontWeight(.semibold)
                                .padding(.leading)
                            
                            VStack(spacing: 20){
                            ForEach(ord.dishes, id: \.id){
                                dish in
                                VStack{
                                    NavigationLink(destination:
                                        DishDetailsView(dish: dish, restaurant: self.order.restChosen).navigationBarHidden(false)
                                    ) {
                                        DishCard(urlImage: FBURLImage(url: dish.coverPhotoURL, imageAspectRatio: .fill), dishName: dish.name, dishIngredients: dish.description, price: self.restDishVM.formatPrice(price: dish.price))
                                    }
                                }
                            }
                        }
                            }
                        }
                    }
                }
                
            }
                }
            }
            
            Spacer()
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("My Orders")
            .onAppear {
                print("\(self.order.dishesChosen)")
                if(userProfile.userId != ""){
                    self.order.retrieveOrders(userID: userProfile.userId)
                    print("Past Orders: \(self.order.pastOrders)")
                }
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
