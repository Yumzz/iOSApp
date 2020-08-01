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
        GeometryReader { geometry in
            ZStack{
                MapView(restaurants: self.restaurants).edgesIgnoringSafeArea(.all)
                VStack {
                    
                    HStack(alignment: .top){
                        NavigationLink(destination: RestaurantSearchListView( isNavigationBarHidden: self.$isNavigationBarHidden)){
                            SearchBarButton(strLabel: "List")
                            }
                        RestaurantSearchbarView(strSearch: self.$strSearch)
                            .padding([.leading, .trailing])
                        
                        
                        }.background(Color.white)
                    
                    Spacer()
                    HStack(spacing: 10){
                        Spacer()
                        Button(action: {
                            //Inspiration: Coordinator Class has mapView function that zooms in on user location
                            
                        }) {
                            Image(systemName: "location")
                            
                        }.padding()
                            .background(Color(UIColor.tertiarySystemBackground))
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .frame(width: geometry.size.width - 60)
                    .padding(.bottom, 25)
                    
                }
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
    }
}

struct RestaurantMapView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantMapView()
    }
}

