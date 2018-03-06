//
//  Geocoder.swift
//  RSR-3
//
//  Created by Parvin Sital on 06/03/2018.
//  Copyright © 2018 Parvin Sital. All rights reserved.
//

import Foundation
import CoreLocation

class Geocoder: CLGeocoder {
    
    //MARK: - TODO
    // code commenting
    // clean up code
    
    
    
    // last time and place we successfully fetched
    var timeOfLastFetch = Date()
    var locationOfLastFetch = CLLocation()
    var firstFetch = true
    var currentAddress = ""
    var currentSubAddress = ""
    
    override init() {
        super.init()
        print("Geocoder initialized")
    }
    
    
    func tryNewFetchRequestForLocation(_ currentLocation: CLLocation, currentTime: Date) {
        if firstFetch {
        
            LocationService.sharedInstance.stopUpdatingLocations()
            self.firstFetch = false
            
            fetchRequestForLocation(currentLocation, completion: { (address, subAddress) in
                self.updateTimeAndLocationOfLastFetchRequest(currentLocation: currentLocation, currentTime: currentTime)
                self.currentAddress = address
                self.currentSubAddress = subAddress
                print("Got first address! - updated time and locatin of last fetch")
                
                LocationService.sharedInstance.startUpdatingLocations()
            })
        } else {
            
            let isWithinRangeOfPreviousLocation = locationOfLastFetch.distance(from: currentLocation) < 10
            let isWithinTimeInterval = currentTime.timeIntervalSince(timeOfLastFetch) < 60 * 3
            
            switch (isWithinRangeOfPreviousLocation, isWithinTimeInterval) {
            case (true, true):
                print("Not fetching: Within range. Within time")
                break
            case (true, false):
                print("Not fetching: Within range. Out of time - use last fetch")
                break
            case (false, true):
                print("Fetching: Out of range - need new fetch")
                fetchRequestForLocation(currentLocation, completion: { (address, subAddress) in
                    self.currentAddress = address
                    self.currentSubAddress = subAddress
                    self.updateTimeAndLocationOfLastFetchRequest(currentLocation: currentLocation, currentTime: currentTime)
                })
                break
            case (false, false):
                print("Fetching: Out of range. Out of time - need new fetch")
                fetchRequestForLocation(currentLocation, completion: { (address, subAddress) in
                    self.currentAddress = address
                    self.currentSubAddress = subAddress
                    self.updateTimeAndLocationOfLastFetchRequest(currentLocation: currentLocation, currentTime: currentTime)
                })
                break
            }
        }
    }

    func updateTimeAndLocationOfLastFetchRequest(currentLocation: CLLocation, currentTime: Date) {
        self.locationOfLastFetch = currentLocation
        self.timeOfLastFetch = currentTime
    }
    
    
    func fetchRequestForLocation(_ location: CLLocation, completion: @escaping (String, String) -> ()) {
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("we have an error")
                return
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    
                    guard let street = placemark.thoroughfare else { return }
                    guard let postalCode = placemark.postalCode else { return }
                    guard let city = placemark.locality else { return }
                    print("grabbing address")
                    
                    let address = "\(street), "
                    let subAddress = "\(postalCode), \(city)"
                    completion(address, subAddress)
                }
            }
        }
    }
}
