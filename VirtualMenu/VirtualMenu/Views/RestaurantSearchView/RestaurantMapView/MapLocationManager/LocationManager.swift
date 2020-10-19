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
    @Published var location: CLLocation? = nil
    
    
    override init(){
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        print("location: \(locations[locations.count-1])")
        self.location = locations[locations.count-1]
    }
}

extension LocationManager: CLLocationManagerDelegate{
    
    
}

