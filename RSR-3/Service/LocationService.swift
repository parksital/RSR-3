//
//  Service.swift
//  RSR-3
//
//  Created by Parvin Sital on 05/03/2018.
//  Copyright © 2018 Parvin Sital. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {
    

    //MARK: - Properties
    static let sharedInstance = LocationService()
    let locationManager: CLLocationManager
    var location = CLLocation()
    var geocoder = Geocoder()
    
    
    //MARK: - Initialization
    override private init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        super.init()
        
        locationManager.delegate = self
        
        print("Location Service initialized")
    }
    
    
    //MARK: - Methods
    func stopUpdatingLocations() {
        locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocations() {
        locationManager.startUpdatingLocation()
    }
}
//MARK: - Extension
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // this is called when the authorization status changes.
        
        // check the new status
        switch status {
        case .denied:
            print("User has denied authorization. Show alert")
        case .authorizedWhenInUse:
            print("We have authorization. Proceed by presenting location")
            locationManager.startUpdatingLocation()
        case .notDetermined:
            print("Auth status undetermined. Requesting authorization.")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            print("auth status: OK always.")
        case .restricted:
            print("User has restricted device. Show alert")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else {
            print("nothing in locations")
            return
        }
        geocoder.tryNewFetchRequestForLocation(currentLocation, currentTime: Date())
        
        // set location to currentLocation
        self.location = currentLocation
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
}
