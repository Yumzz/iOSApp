//
//  RestaurantAnnotation.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/29/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import Foundation
import MapKit
import SwiftUI

final class RestaurantAnnotation: NSObject, MKAnnotation{
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(restaurant: RestaurantFB){
        print("annotation created")
        self.title = restaurant.name
        let lat: CLLocationDegrees = restaurant.coordinate.latitude
        let lon: CLLocationDegrees = restaurant.coordinate.longitude
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
}


