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
    
    var body: some View {
                NavigationView{
                ZStack{
                    ScrollView{
                        VStack(spacing: 10){
                            FBURLImage(url: restaurant.coverPhotoURL, imageWidth: 375, imageHeight: 240)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .padding(.bottom, 10)
                                .padding(.leading, 30)
                                .padding(.trailing, 30)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
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
                                    HStack{
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
                                                    .frame(width: 60)
                                            }
                                            .padding()
                                            .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                            .background(Color.white)
                                            .cornerRadius(20)
                                        }.padding(.leading, 40)
                                        
                                        Button(action: {

                                        }) {
                                            HStack {
                                                Image(systemName: "scanner")
                                                    .font(.system(size: 18))
                                            }
                                            .padding()
                                            .foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1)))
                                            .background(Color.white)
                                            .cornerRadius(20)
        
                                        }
                            
                                        Spacer()
                                    }
                                    VStack{
                                        HStack{
                                            Text("Popular").font(.system(size: 24, weight: .semibold))
                                                .padding(.leading, 40)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitle("")
            }
        }
}


struct RestaurantHomeView_Previews: PreviewProvider {
    static var previews: some View {
        //RestaurantHomeView()
        EmptyView()
    }
}

