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
                .overlay(
                    BottomSheetModal(display: self.$click.isClicked, backgroundColor: .constant(Color(UIColor().colorFromHex("#F88379", 1))), rectangleColor: .constant(Color.white)) {
                        VStack{
                            ZStack (alignment: .trailing){
                                VStack {
                                    //image, name, ethnicity, rating, menu button
                                    HStack {
                                        //                                Image(self.click.restChosen)
                                        Text("Name: \(self.click.restChosen!.name)")
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
                                        VStack (alignment: .leading){
                                            Text("Type: \(self.click.restChosen!.ethnicity)")
                                                .font(.custom("Open Sans", size: 20))
                                                .foregroundColor(.black)
                                                //.frame(width: 150, height: 20)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .padding(.bottom, 11)
                                        }
                                    }
                                    HStack {
                                        VStack (alignment: .leading){
                                            Text("Location: Latitude: \(self.click.restChosen!.coordinate.latitude) Longitude: \(self.click.restChosen!.coordinate.longitude)")
                                                .font(.custom("Open Sans", size: 20))
                                                .foregroundColor(.black)
                                                //.frame(width: 150, height: 20)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .padding(.bottom, 11)
                                        }
                                    }
                                    HStack {
                                        VStack (alignment: .leading){
                                            Text("AveragePrice: \(self.click.restChosen!.averagePrice)")
                                                .font(.custom("Open Sans", size: 20))
                                                .foregroundColor(.black)
                                                //.frame(width: 150, height: 20)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .padding(.bottom, 11)
                                        }
                                    }
                                    HStack{
                                        VStack(alignment: .center){
                                            NavigationLink(destination: MenuSelectionView(restChosen: self.click.restChosen!).navigationBarHidden(false)){
                                                Text("Click here for \(self.click.restChosen!.name)'s Menu Details")
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                )
            }
        }
        .navigationBarTitle("Map")
        .navigationBarHidden(self.isNavigationBarHidden)
        .onAppear(){
            self.isNavigationBarHidden = true
            
            var counter = 0
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { (timer) in
                print("counter: \(counter)")
                counter = counter + 1
                if(counter == 4){
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
