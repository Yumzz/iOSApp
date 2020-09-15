//
//  RestaurantMapView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/06/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import MapKit
import Firebase

struct RestaurantMapView: View {
    @State var strSearch: String = ""
    @State private var restaurants: [RestaurantFB] = [RestaurantFB]()
    @State var restChosen: RestaurantFB? = nil
    @State var isClicked = false
    @State private var bottomSheetShown = false
    
    @State var region: [MKCoordinateRegion] = [MKCoordinateRegion]()
    
    @State var isNavigationBarHidden: Bool = true
    
    @ObservedObject var restMapVM = RestaurantMapViewModel()
    
    @ObservedObject var click: isClick = isClick()
    @State var show = false

    
    private var locationManager = LocationManager()
    var body: some View {
        GeometryReader { geometry in
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
                                .background(Color(UIColor().colorFromHex("#F88379", 1)))
                                .cornerRadius(10.0)
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
                            .background(Color(UIColor().colorFromHex("#F88379", 1)))
                            .cornerRadius(10.0)

                        }.padding(.leading, UIScreen.main.bounds.width/1.3)
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
                    if (self.click.isClicked) {
                        BottomSheetView(isOpen: self.$bottomSheetShown, maxHeight: geometry.size.height*0.8) {
                            if self.click.restChosen != nil {
                                MapViewBottomView(restChosen: self.click.restChosen!)
                            }
                        }
                    }
                    
//                    .overlay(
//                        BottomSheetModal(display: self.$click.isClicked, backgroundColor: .constant(Color(UIColor().colorFromHex("#FFFFFF", 1))), rectangleColor: .constant(Color(UIColor().colorFromHex("#656565", 1)))) {
//                            MapViewBottomView(restChosen: self.click.restChosen!)
//                        }
//                    )
                }
            }
        }
        .navigationBarTitle("Map")
        .navigationBarHidden(self.isNavigationBarHidden)
        .onAppear(){
            Auth.auth().fetchSignInMethods(forEmail: userProfile.emailAddress) { (methods, err) in
                print(methods)
            }
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
}



struct RestaurantMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantMapView()
        }
    }
}
