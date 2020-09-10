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

    func mapView(_ mapView: MKMapView,
           annotationView view: MKAnnotationView,
           calloutAccessoryControlTapped control: UIControl){
//        When annotation tapped, this is called
//        guard let rest = view.annotation as? RestaurantAnnotation else {return nil}
//        print("yes: \(view.annotation?.title)")
        //bring up bottom sheet modal on Restaurant MapView
        //need to flip variable there by throwing notification
        if(view.annotation is RestaurantAnnotation){
            let rest = (view.annotation as! RestaurantAnnotation).restInfo
            let restaurantData: [String: RestaurantFB] = ["Restaurant": rest]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "annotationPressed"), object: nil, userInfo: restaurantData)
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Restaurant"
        
        if annotation is RestaurantAnnotation {
            if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier){
                annotationView.annotation = annotation
                return annotationView
            }
            else{
                let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.isEnabled = true
                annotationView.canShowCallout = true
                annotationView.accessibilityLabel = "hello"
                
                let btn = UIButton(type: .detailDisclosure)
                annotationView.rightCalloutAccessoryView = btn
                
                return annotationView
            }
        }
        return nil
    }
    
    
    
   
}

