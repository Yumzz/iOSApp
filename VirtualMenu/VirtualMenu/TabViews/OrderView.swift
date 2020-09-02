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
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
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
                    CompleteOrderCard()
                    SaveOrderButton().onTapGesture {
                        //what do we do here to save orders for user?
                        //have dishes here, need to store into user's orders on FB
                        let ord = Order(dishes: self.order.dishesChosen, totalPrice: self.order.totalCost)
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
