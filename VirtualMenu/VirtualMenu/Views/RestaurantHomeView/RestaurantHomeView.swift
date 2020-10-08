//
//  RestaurantHomeView.swift
//  VirtualMenu
//
//  Created by Sally Gao on 10/7/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct RestaurantHomeView: View {
    var restaurant: RestaurantFB
    @ObservedObject var menuSelectionVM: MenuSelectionViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(restaurant: RestaurantFB) {
        self.restaurant = restaurant
        self.menuSelectionVM = MenuSelectionViewModel(restaurant: self.restaurant)
    }
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack(spacing: 10){
                    ZStack{
                        FBURLImage(url: restaurant.coverPhotoURL, imageWidth: 375, imageHeight: 240)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding(.bottom, 10)
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                                }) {
                            Image(systemName: "arrow.left").foregroundColor(.black)
                        }
                    }
                    Spacer()
                    ScrollView{
                        VStack{
                            HStack{
                                Text(restaurant.name).font(.system(size: 24, weight: .semibold)).tracking(-0.41).padding(.leading, 40)
                                Spacer()
                                
                            }
                            HStack{
                                Text("$$$ | Asian |200m | 9 am – 5 pm").font(.system(size: 14, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.77, green: 0.77, blue: 0.77, alpha: 1))).tracking(-0.41).padding(.leading, 40)
                                Spacer()
                            }
                            HStack{
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(#colorLiteral(red: 0, green: 0.7333333492279053, blue: 0.4693332314491272, alpha: 1)))
                                .frame(width: 45, height: 20)
                                    .padding(.leading,40)
                                Text("(298 reviews)").font(.system(size: 14, weight: .semibold)).tracking(-0.41)
                                
                                Spacer()
                            }
                            HStack(spacing: 10){
                                Button(action: {
                                    guard let number = URL(string: "tel://" + restaurant.phone) else { return }
                                UIApplication.shared.open(number)

                                }) {
                                    HStack {
                                        Image(systemName: "phone.fill")
                                            .font(.system(size: 18))
                                        Text("Call Restaurant")
                                            .font(.system(size: 10))
                                            .font(.footnote)
                                            .frame(width: 150)
                                    }
                                    .padding()
                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .frame(width: 150, height: 36)
                                }.padding(.leading, 40)
                                Spacer()
                                Button(action: {

                                }) {
                                    HStack {
                                        Image(systemName: "qrcode.viewfinder")
                                            .font(.system(size: 18))
                                    }
                                    .padding()
                                    .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                    .background(Color.white)
                                    .cornerRadius(20)

                                }
                    
                                Spacer()
                            }.padding()
                            VStack{
                                HStack{
                                    Text("Popular").font(.system(size: 24, weight: .semibold))
                                        .padding(.leading, 40)
                                    Spacer()
                                }
                            }
                            
                            ScrollView(.horizontal) {
                                HStack(spacing: 30) {
                                    ForEach(self.menuSelectionVM.featuredDishes, id: \.id){
                                        dish in
                                        PopularDishCard(dish: dish)
                                    }
                                }
                            }.frame(height: 135).padding()
                           
                        }.padding()
                    }
                }
            }
        }
        .background(Color(red: 0.953, green: 0.945, blue: 0.933))
        .edgesIgnoringSafeArea(.all)
        .navigationBarHidden(true)
        .navigationBarTitle("")
    }
    
}

struct PopularDishCard: View {
    var dish: DishFB
    
    var body: some View {
        VStack {
            HStack {
                FBURLImage(url: dish.coverPhotoURL, imageWidth: 175, imageHeight: 88)
                    .frame(width: 175, height: 88)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            HStack{
                Text(dish.name).foregroundColor(Color.black).font(.system(size: 18, weight: .bold)).tracking(-0.41)
                Spacer()
            }
            HStack{
                Text(String(dish.price)).font(.system(size: 12, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
                Spacer()
            }
        }.frame(width: 175, height: 130)
    }
}


struct RestaurantHomeView_Previews: PreviewProvider {
    static var previews: some View {
        //RestaurantHomeView()
        EmptyView()
    }
}

