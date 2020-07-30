//
//  MapView.swift
//  VirtualMenu
//
//  Created by Valentin Porcellini on 27/06/2020.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let restaurants: [RestaurantFB]
    
    func makeUIView(context: Context) -> MKMapView{
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        return map
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
     
    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>){
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MapView(restaurants: [])
        }
        
    }
}
