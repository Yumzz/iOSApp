//
//  HomeScreenView.swift
//  VirtualMenu
//
//  Created by William Bai on 10/6/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI

struct HomeScreenView: View {
    @ObservedObject var HomeScreenVM : HomeScreenViewModel
    
    @State private var showAccount = false

    init() {
        self.HomeScreenVM = HomeScreenViewModel()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(#colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)).edgesIgnoringSafeArea(.all)
                ScrollView(.vertical) {
                    VStack {
                        HStack {
                            Text("Yumzz").font(.system(size: 36, weight: .bold)).frame(alignment: .leading)
                            Spacer()
                            Image(systemName: "qrcode.viewfinder")
                                .font(.system(size: 24, weight: .bold)).padding()
                            if (userProfile.profilePhoto == nil){
                            Image(systemName: "person.crop.square.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 36, height: 36)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture {
                                    self.showAccount = true
                                }
                                .sheet(isPresented: self.$showAccount) {
                                    AccountProfileView()
                                    //dismiss once confirmation alert is sent
                                }
                            }
                            else{
                                Image(uiImage: userProfile.profilePhoto!.circle!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 36, height: 36)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
                                        self.showAccount = true
                                    }
                                    .sheet(isPresented: self.$showAccount) {
                                        AccountProfileView()
                                        //dismiss once confirmation alert is sent
                                    }
                            }
                        }.foregroundColor(Color(#colorLiteral(red: 0.88, green: 0.36, blue: 0.16, alpha: 1))).frame(alignment: .top).padding()
                            
                        
                        HStack {
                            Text("Near you").font(.system(size: 24, weight: .semibold))
                            Spacer()
                        }.padding()
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                ForEach(self.HomeScreenVM.allRestaurants, id:\.id) { restaurant in
                                    NavigationLink(
                                        destination: RestaurantHomeView(restaurant: restaurant)
                                    ) {
                                        HSRestaurantCard(restaurant: restaurant, HomeScreenVM: self.HomeScreenVM)
                                    }
                                }
                            }
                        }.frame(height: 150).padding()
                        HStack{
                            Text("Popular in Pleasanton").font(.system(size: 24, weight: .semibold))
                            Spacer()
                        }.padding()
                        
                        ScrollView(.horizontal){
                            HStack(spacing: 20) {
                                ForEach(self.HomeScreenVM.allRestaurants, id:\.id) { restaurant in
                                    NavigationLink(
                                        destination: RestaurantHomeView(restaurant: restaurant)
                                    ) {
                                        HSRestaurantCard(restaurant: restaurant, HomeScreenVM: self.HomeScreenVM)
                                    }
                                }
                            }
                        }.frame(height: 150).padding()
                        
                        Spacer()
                    }.padding(.top, geometry.safeAreaInsets.top)
                }
//                .background(Color(red: 0.953, green: 0.945, blue: 0.933))
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            }.navigationBarTitle("").navigationBarHidden(true)
        }
    
    }
}

struct HSRestaurantCard: View {
    var restaurant: RestaurantFB
    var HomeScreenVM : HomeScreenViewModel
    
    var body: some View {
            VStack {
                HStack {
                    FBURLImage(url: restaurant.coverPhotoURL, imageWidth: 175, imageHeight: 88)
                        .frame(width: 175, height: 88)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
                HStack{
                    Text(restaurant.name).foregroundColor(Color.black).font(.system(size: 18, weight: .bold)).tracking(-0.41)
                    Spacer()
                }
                HStack{
                    Text("\(restaurant.price) | \(restaurant.ethnicity) | \(HomeScreenVM.getDistFromUser(coordinate: restaurant.coordinate)) miles").font(.system(size: 12, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
                    Spacer()
                }
            }.frame(width: 175, height: 150)
            .padding(.leading, 10)
        }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
