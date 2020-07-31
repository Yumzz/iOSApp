//
//  Coordinator.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/29/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import MapKit

final class Coordinator: NSObject, MKMapViewDelegate {
    var locationManager = LocationManager()
    var control: MapView
    
    init(_ control: MapView){
        self.control = control
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]){
        
        if let annotationView = views.first {
            if let annotation = annotationView.annotation {
                
                if annotation is MKUserLocation {
                    
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    mapView.setRegion(region, animated: true)
                }
                
                
            }
            
        }
        
    }
   
}

