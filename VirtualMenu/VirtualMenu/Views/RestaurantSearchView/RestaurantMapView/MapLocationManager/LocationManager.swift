//
//  LocationManage.swift
//  VirtualMenu
//
//  Created by Rohan Tyagi on 7/29/20.
//  Copyright © 2020 Rohan Tyagi. All rights reserved.
//

import SwiftUI
import MapKit

class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    var location: CLLocation? = nil
    
    
    override init(){
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    
}

extension LocationManager: CLLocationManagerDelegate{
    
    
}

