//
//  RestaurantMapView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/06/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import MapKit

struct RestaurantMapView: View {
    @State var strSearch: String = ""
    @State private var restaurants: [RestaurantFB] = [RestaurantFB]()
    @State var restChosen: RestaurantFB? = nil
    @State var isClicked = false
    
    @State var region: [MKCoordinateRegion] = [MKCoordinateRegion]()
    
    @State var isNavigationBarHidden: Bool = true
    
    @ObservedObject var restDishVM = RestaurantDishViewModel()
    
    @ObservedObject var click: isClick = isClick()
    
    private var locationManager = LocationManager()
    var body: some View {
        ZStack{
            MapView(restaurants: self.restaurants, region: self.region).edgesIgnoringSafeArea(.all)
            VStack {
                
                HStack(){
                    NavigationLink(destination: RestaurantSearchListView( isNavigationBarHidden: self.$isNavigationBarHidden)){
                        
                        Text("List")
                            .foregroundColor(Color(.white))
                            .padding(8)
                            .background(Color(.systemBlue))
                            .cornerRadius(10.0)
                            .padding(.leading)
                    }
                        RestaurantSearchbarView(strSearch: self.$strSearch)
                            .padding([.leading, .trailing])
                        }

                    
                    RestaurantSearchbarView(strSearch: self.$strSearch)
                        .padding([.leading, .trailing])
                    
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Spacer()
                    
                    Button(action: {
                        self.region.append(MKCoordinateRegion(center: self.locationManager.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                        
                    }) {
                        Image(systemName: "location")
                    }
                    .padding()
                    .background(Color(UIColor.tertiarySystemBackground))
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    
                    Spacer()
                        .frame(maxWidth: 0)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 25)
                .overlay(BottomSheetModal(display: self.$click.isClicked, backgroundColor: .constant(Color(UIColor().colorFromHex("#F88379", 1))), rectangleColor: .constant(Color.white)) {
                        ZStack (alignment: .trailing){
                            VStack(alignment: .leading) {
                                //name, image, address, number, hours, price, and menu
                                HStack {
                                    Text(self.click.restChosen!.name)
                                        .padding(.horizontal)
                                        .foregroundColor(.black)
                                        .font(.custom("Futura Bold", size: 24))
                                    Spacer()
                                    Button("X") {
                                        NotificationCenter.default.post(name: Notification.Name(rawValue: "XPressed"), object: nil)
                                        //need to call for refreshing
                                    }
                                    .foregroundColor(.black)
                                    .padding(.trailing)
                                    .font(.custom("Futura Bold", size: 15))
                                }
                                
                                HStack {
                                    Image("initial_screen_back")
                                    .resizable()
                                    .frame(width: 150, height:150)
                                    .clipShape(Circle())
                                
                                    VStack (alignment: .leading){
                                        Image("address")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .padding(.bottom, 5)
                                        Image("phone")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .padding(.bottom, 5)
//                                        Image("hours")
//                                            .padding(.bottom, 10)
                                        Image("price")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .padding(.bottom, 5)
                                        Image("menu")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .padding(.bottom, 5)
                                    }
                                
                            
                                VStack (alignment: .leading){
                                    Text("\((self.click.restChosen?.address)!)")
                                        .font(.custom("Open Sans", size: 20))
                                        .foregroundColor(.black)
                                        //.frame(width: 150, height: 20)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.bottom, 10)
                                    Text("\((self.click.restChosen?.phone)!)")
                                        .font(.custom("Open Sans", size: 20))
                                        .foregroundColor(.black)
                                        //.frame(width: 150, height: 20)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.bottom, 15)
                                
                                    //if statement based on price level
                                    Text("Price")
                                        .font(.custom("Open Sans", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.bottom,15)
                                
                                    NavigationLink(destination: MenuSelectionView(restChosen: self.click.restChosen!).navigationBarHidden(false)){
                                        Text("Menu")
                                            .font(.custom("Open Sans", size: 20))
                                            .foregroundColor(.black)
                                            .foregroundColor(.black)
                                            .padding(.bottom, 15)
                                        }
                                }.onTapGesture {
                                    self.click.isClicked = false
                                    }
                            }
                                Spacer()
                            }
                            
                        }
                    
                    
                }
            )

        }
        .navigationBarTitle("Map")
        .navigationBarHidden(self.isNavigationBarHidden)
        .onAppear(){
            self.isNavigationBarHidden = true
            
            var counter = 0
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { (timer) in
                print("counter: \(counter)")
                counter = counter + 1
                if(counter == 2){
                    timer.invalidate()
                }
                self.restDishVM.fetchRestaurantsFB()
                self.restaurants = self.restDishVM.allRests
            }
            //need to show only ones within certain radius (city radius)
        }
        .onDisappear(){
            self.isNavigationBarHidden = false
        }
    }
}



struct RestaurantMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantMapView()
        }
    }
}
