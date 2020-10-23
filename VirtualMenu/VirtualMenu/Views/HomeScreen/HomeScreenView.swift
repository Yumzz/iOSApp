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
    
    @State var restaurants = [RestaurantFB]()
    
    @State var cityRests = [String: [RestaurantFB]]()
    
    @State var cities = [String]()
    
    let dispatchGroup = DispatchGroup()
    
    @EnvironmentObject var order : OrderModel
    
    var locationManager = LocationManager()

    init() {
        self.HomeScreenVM = HomeScreenViewModel(dispatch: dispatchGroup)
    }
    
    var body: some View {
        Group {
            if(!self.order.dishesChosen.isEmpty){
                view.overlay(overlay, alignment: .bottom)
            } else {
                 view
             }
         }
    }
    
    var overlay: some View {
        VStack{
            NavigationLink(destination: ReviewOrder()){
                ViewCartButton(dishCount: self.order.dishesChosen.count)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .circular))
            }
            Spacer().frame(width: 0, height: 10)
        }
    }
    
    var view: some View{
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
                        HStack(spacing: 30) {
                            ForEach(self.restaurants, id:\.id) { restaurant in

                                NavigationLink(
                                    destination: RestaurantHomeView(restaurant: restaurant, distance: self.HomeScreenVM.getDistFromUser(coordinate: restaurant.coordinate))
                                ) {
                                    HSRestaurantCard(restaurant: restaurant, location: self.HomeScreenVM.getDistFromUser(coordinate: restaurant.coordinate))
                                }
                            }
                        }
                    }.frame(height: 150).padding()
                    
                    ForEach(self.cities, id:\.self) { city in
                        
                        HStack{
                            Text("Popular in \(city)").font(.system(size: 24, weight: .semibold))
                            Spacer()
                        }.padding()
                    
                    ScrollView(.horizontal){
                        HStack(spacing: 30) {
                                
                                ForEach(self.cityRests[city]!, id:\.self) { rest in

                                    NavigationLink(
                                        destination: RestaurantHomeView(restaurant: rest, distance: self.HomeScreenVM.getDistFromUser(coordinate: rest.coordinate))
                                    ) {
                                        HSRestaurantCard(restaurant: rest, location: self.HomeScreenVM.getDistFromUser(coordinate: rest.coordinate))
                                    }


                                }

                            }
                        }.frame(height: 135).padding()
                    }
                    Spacer()
                    
                }.padding(.top, geometry.safeAreaInsets.top)
            }
//                .background(Color(red: 0.953, green: 0.945, blue: 0.933))
            .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }.navigationBarTitle("").navigationBarHidden(true)
        .onAppear(){
//                NotificationCenter.add
            self.dispatchGroup.notify(queue: .main){
                self.restaurants = self.HomeScreenVM.allRestaurants
                for x in self.restaurants {
                    if(self.cityRests[x.cityAddress] == nil){
                        self.cityRests[x.cityAddress] = []
                    }
                    if(!self.cityRests[x.cityAddress]!.contains(x)){
                        self.cityRests[x.cityAddress]!.append(x)
                    }
                    if(!cities.contains(x.cityAddress)){
                        self.cities.append(x.cityAddress)
                    }
                }
                
            }
        }
    }
}
}

struct HSRestaurantCard: View {
    var restaurant: RestaurantFB
//    var HomeScreenVM : HomeScreenViewModel
    var location: Double
    
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
                    Text("\(restaurant.price) | \(restaurant.ethnicity) | \(self.location.removeZerosFromEnd()) miles").font(.system(size: 12, weight: .semibold)).foregroundColor(Color(#colorLiteral(red: 0.7, green: 0.7, blue: 0.7, alpha: 1))).tracking(-0.41)
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
