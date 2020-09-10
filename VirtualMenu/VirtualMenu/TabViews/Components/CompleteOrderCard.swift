//
//  OrderCard2.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 29/08/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct CompleteOrderCard: View {
    
    var tax: Double = 0.0
    var total: Double = 0.0
    @State var isFavorite: Bool = false
    
    
    @EnvironmentObject var order : OrderModel
    
    
    var body: some View {
        ZStack{
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                Spacer()
                FBURLImage(url: self.order.restChosen.coverPhotoURL)
                    .frame(width: 96, height: 96)
                
                Spacer()
                
//                Button(action: {
//                    self.isFavorite.toggle()
//                }){
//                    if !isFavorite {
//                        Image(systemName: "heart")
//                            .resizable()
//                            .frame(width: 24, height: 24)
//                            .foregroundColor(Color.red)
//                    } else {
//                        Image(systemName: "heart.fill")
//                            .resizable()
//                            .frame(width: 24, height: 24)
//                            .foregroundColor(Color.red)
//                    }
//                }
                
            }
            .padding(.top)
            .padding(.horizontal)
            
            ScrollView{
                VStack {
                        
                    ForEach(self.order.dishesChosen, id: \.id){ dish in
                            HStack {
                                Text("\(dish.name)")
                                .foregroundColor(Color.secondary)
                            Spacer()
                                
                                Text("\(DishFB.formatPrice(price: dish.price))")
                                .foregroundColor(Color.secondary)
                                
                                Button("X") {
                                    let dis = DispatchGroup()
                                    dis.enter()
                                    self.order.deleteDish(dish: dish, dis: dis)
                                    //need to call for refreshing
                                }.foregroundColor(.black)
                                .padding(.trailing)
                            }
                        

                    }.padding(.top)
                    .padding(.horizontal, 32)
                    
                }
            }
            
            
//            HStack {
//                Text("Edamame")
//                    .foregroundColor(Color.secondary)
//                Spacer()
//
//                Text("$ 6.50")
//                    .foregroundColor(Color.secondary)
//            }

            
//            Spacer()
//                .frame(height: 5)
//            
            HStack {
                Text("Subtotal")
                
                Spacer()
                
                Text("\(DishFB.formatPrice(price: order.totalCost))")
            }
            .padding(.horizontal, 32)
            
            HStack {
                Text("Tax")
                
                Spacer()
                
                Text("$ 0.00")
            }
            .padding(.horizontal, 32)
            
            Divider()
                .background(Color.primary)
                .padding(.horizontal)
            
            HStack {
                Text("Total")
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(DishFB.formatPrice(price: order.totalCost))")
                    .fontWeight(.bold)
            }
            .padding(.bottom)
            .padding(.horizontal, 32)
            
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .padding()
        .shadow(radius: 6)
    }
    }
}

struct CompleteOrderCard_Previews: PreviewProvider {
    static var previews: some View {
        CompleteOrderCard(tax: 0, total: 14.50 )
    }
}

