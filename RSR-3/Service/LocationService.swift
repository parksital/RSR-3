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
    
    //MARK: - Constants
    private let secondsBetweenLocationUpdates = 10.0

    //MARK: - Properties
    static let sharedInstance = LocationService()
    let locationManager: CLLocationManager
    var location: CLLocation?
    var geocoder = Geocoder()
    
    
    //MARK: - Initialization
    override private init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        super.init()
        
        locationManager.delegate = self
        print("Location Service initialized")
    }
    
    //MARK: - Methods
    private func stopUpdatingLocations() {
        self.locationManager.stopUpdatingLocation()
    }
    
    @objc private func startUpdatingLocations() {
        self.locationManager.startUpdatingLocation()
    }
}
//MARK: - Extension
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // this is called when the authorization status changes.
        
        // action based on authorization status
        switch status {
        case .denied:
            print("User has denied authorization. Show alert")
        case .authorizedWhenInUse:
            print("We have authorization. Proceed by presenting location")
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            print("Auth status undetermined. Requesting authorization.")
            self.locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            print("auth status: OK always.")
        case .restricted:
            print("User has restricted device.")
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //this is called every time the user's location changes
        
        // if there is anything in locations.last, put it in currentLocation
        guard let currentLocation = locations.last else {
            print("nothing in locations")
            return
        }
    
        // every time we get a new location, try to fetch the geocoded data
        geocoder.tryNewFetchRequestForLocation(currentLocation, currentTime: Date())
        
        // stop updating locations, so we don't make too many requests in a short time
        self.stopUpdatingLocations()
        
        // Wait X seconds. Start updating locations again.
        Timer.scheduledTimer(timeInterval: secondsBetweenLocationUpdates, target: self, selector: #selector(startUpdatingLocations), userInfo: nil, repeats: false)
        
        // set location to currentLocation
        self.location = currentLocation
        
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
}
