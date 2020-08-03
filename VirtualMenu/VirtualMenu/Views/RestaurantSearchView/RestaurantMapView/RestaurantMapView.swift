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
    
    @State var isNavigationBarHidden: Bool = true
    
    @ObservedObject var restDishVM = RestaurantDishViewModel()
    
    private var locationManager = LocationManager()
    var body: some View {
        ZStack{
            MapView(restaurants: self.restaurants).edgesIgnoringSafeArea(.all)
            VStack {
                HStack(){
                    NavigationLink(destination: RestaurantSearchListView( isNavigationBarHidden: self.$isNavigationBarHidden)){
                        Text("List")
                            .foregroundColor(Color(.white))
                            .padding(.all, 8)
                        
                    }
                    .background(Color(.systemBlue))
                    .cornerRadius(10.0)
                    .padding(.trailing, 16)
                    
                    RestaurantSearchbarView(strSearch: self.$strSearch)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                HStack(spacing: 16){
                    Spacer()
                    Button(action: {
                        //Inspiration: Coordinator Class has mapView function that zooms in on user location
                        
                    }) {
                        Image(systemName: "location")
                        
                    }.padding()
                        .background(Color(UIColor.tertiarySystemBackground))
                        .clipShape(Circle())
                        .shadow(radius: 5)
                    
                    Spacer()
                        .frame(maxWidth: 0)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 25)
                
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

