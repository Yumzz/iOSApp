//
//  MapViews.swift
//  VirtualMenu
//
//  Created by Sally Gao on 10/11/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import MapKit

struct MapViews: UIViewRepresentable {
    let restaurants: [RestaurantFB]
    let region: [MKCoordinateRegion]
    
    func makeUIView(context: Context) -> MKMapView{
        let map = MKMapView()
        map.showsUserLocation = true
        map.delegate = context.coordinator
        return map
    }
    
    func makeCoordinator() -> CoordinatorRegion {
        CoordinatorRegion(self)
    }
    
     
    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapViews>){
        if(region.count > 0){
            view.setRegion(self.region.last!, animated: true)
        }
        updateAnnotations(from: view)
    }
    
    private func updateAnnotations(from mapView: MKMapView){
        mapView.removeAnnotations(mapView.annotations)
        let annotations = self.restaurants.map(RestaurantAnnotation.init)
        
        mapView.addAnnotations(annotations)
    }
    
    
}
