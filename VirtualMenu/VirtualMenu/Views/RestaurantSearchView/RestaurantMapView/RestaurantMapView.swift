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
    
    @ObservedObject var restMapVM = RestaurantMapViewModel()
    
    @ObservedObject var click: isClick = isClick()
    @State var show = false

    
    private var locationManager = LocationManager()
    var body: some View {
        ZStack{
            if self.show{
                GeometryReader{_ in
                    Loader()
                }.background(Color.black.opacity(0.45))
            }
            else{
                MapView(restaurants: self.restaurants, region: self.region).edgesIgnoringSafeArea(.all)
                VStack {
                    HStack{
                    
                        NavigationLink(destination: RestaurantSearchListView( isNavigationBarHidden: self.isNavigationBarHidden)){
                            
                            Text("List")
                                .foregroundColor(Color(.white))
                                .padding(8)
                                .background(Color(UIColor().colorFromHex("#F88379", 1)))
                                .cornerRadius(10.0)
                                .padding(.leading)
                        }
//                            RestaurantSearchbarView(strSearch: self.$strSearch)
//                                .padding([.leading])
                        
                        Button(action: {
                            self.show = true
                            let disp = DispatchGroup()
                            self.restMapVM.fetchRestaurantsBasicInfo(disp: disp)
                            disp.notify(queue: .main){
                                self.restaurants = self.restMapVM.allRests
                                self.show = false
                            }
                        }){
                            Text("Near Me")
                            .foregroundColor(Color(.white))
                            .padding(8)
                            .background(Color(UIColor().colorFromHex("#F88379", 1)))
                            .cornerRadius(10.0)
                            .padding(.leading)
                        }
                        Spacer().frame(width: 10)

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
                                    FBURLImage(url: self.click.restChosen!.coverPhotoURL, imageWidth: 120, imageHeight: 120)
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
                                        Text("\((self.click.restChosen?.streetAddress)!)")
                                            .font(.custom("Open Sans", size: 20))
                                            .foregroundColor(.black)
                                            //.frame(width: 150, height: 20)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.bottom, 15)
                                        Text("\((self.click.restChosen?.phone)!)")
                                            .font(.custom("Open Sans", size: 20))
                                            .foregroundColor(.black)
                                            //.frame(width: 150, height: 20)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .padding(.bottom, 15)
                                        
                                        //if statement based on price level
                                        Text("\((self.click.restChosen?.price)!)")
                                        .font(.custom("Open Sans", size: 20))
                                        .foregroundColor(.black)
                                        .padding(.bottom,15)

//                                        NavigationLink(destination: MenuSelectionView(restChosen: self.click.restChosen!).navigationBarHidden(false)){
//                                            Text("Menu")
//                                                .font(.custom("Open Sans", size: 20))
//                                                .foregroundColor(.black)
//                                                .foregroundColor(.black)
//                                                .padding(.bottom, 15)
//                                        }
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
            }
        }
        .navigationBarTitle("Map")
        .navigationBarHidden(self.isNavigationBarHidden)
        .onAppear(){
            self.isNavigationBarHidden = true
            let disp = DispatchGroup()
            if(self.restMapVM.allRests.isEmpty){
                self.show = true
                self.restMapVM.fetchRestaurantsBasicInfo(disp: disp)
                disp.notify(queue: .main){
                    self.restaurants = self.restMapVM.allRests
                    self.show = false
                }
            }else{
                self.restaurants = self.restMapVM.allRests
            }
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
