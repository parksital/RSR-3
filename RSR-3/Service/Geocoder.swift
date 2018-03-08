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
    
    
    //MARK: - Constants
    private let maxAmountOfMinutes = 1 * 60.0       // fetch every minute
    private let maxDistanceInMeters = 5.0           // or if user travels more than 5m
    
    
    //MARK: - Properties
    // last time and place we successfully fetched
    private var timeOfLastFetch = Date()
    private var locationOfLastFetch = CLLocation()
    private var firstFetch = true   // only true the first time
    
    var currentAddress = "Streetname, "             // placeholder
    var currentAddressDetail = "1234 XY, Amsterdam" // placeholder
    
    //MARK: - Initialization
    override init() {
        super.init()
        print("Geocoder initialized")
    }
    
    //MARK: - Methods
    // didUpdateLocation gets a new location every 10 seconds.
    // in this function, we try to fetch new data every 3 minutes
    func tryNewFetchRequestForLocation(_ currentLocation: CLLocation, currentTime: Date) {
        
        // check if this is the first fetch
        if firstFetch {
            
            // make the request
            fetchRequestForLocation(currentLocation, completion: { (address, addressDetail) in
                
                // this is the completion block.
                // this executes after the fetch
                
                
                // we now have inital data
                // future fetch requests will compare against this inital time and location data
                self.locationOfLastFetch = currentLocation
                self.timeOfLastFetch = currentTime
                
                // we now hold the latest successful fetched data for the viewcontroller to grab
                self.currentAddress = address
                self.currentAddressDetail = addressDetail
                print("Got first address! - updated time and locatin of last fetch")
                
                // set first fetch to false
                self.firstFetch = false
            })
        } else {
            // for every fetch request after the first one
            
            // we want to know:
            // is the user within 10 meters of last succesful fetch location?
            // was the last successful fetch request less than 3 minutes ago?
            let isWithinRangeOfPreviousLocation = locationOfLastFetch.distance(from: currentLocation) < maxDistanceInMeters
            let isWithinTimeInterval = currentTime.timeIntervalSince(timeOfLastFetch) < maxAmountOfMinutes
            
            switch (isWithinRangeOfPreviousLocation, isWithinTimeInterval) {
            case (true, true):
                // user is within 10 meters of last place of successful fetch
                // last successful fetch is not 3 minutes old yet
                
                print("Not fetching: Within range. Within time")
                break
            case (true, false):
                // last successful fetch is older than 3 minutes
                // but the user is still in the area
                
                print("Not fetching: Within range. Out of time - use last fetch")
                break
            case (false, true):
                // the user has traveled more than 10 meters since the last successful fetch
                // within 3 minutes
                
                print("Fetching: Out of range - need new fetch")
                fetchRequestForLocation(currentLocation, completion: { (address, addressDetail) in
                    self.currentAddress = address
                    self.currentAddressDetail = addressDetail
                    
                    self.locationOfLastFetch = currentLocation
                    self.timeOfLastFetch = currentTime
                })
                break
            case (false, false):
                // the last successful fetch was longer than 3 minutes ago
                // and the user has traveled more than 10 meter
                
                print("Fetching: Out of range. Out of time - need new fetch")
                fetchRequestForLocation(currentLocation, completion: { (address, addressDetail) in
                    self.currentAddress = address
                    self.currentAddressDetail = addressDetail
                    
                    self.locationOfLastFetch = currentLocation
                    self.timeOfLastFetch = currentTime
                })
                break
            }
        }
    }
    
    private func fetchRequestForLocation(_ location: CLLocation, completion: @escaping (String, String) -> ()) {
        
        // geocoder tries to get string from coordinates
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("we have an error")
                return
            } else {
                
                // if there are placemarks, and there is a placemark at placemarks[0]
                if let placemarks = placemarks, let placemark = placemarks.first {
                    
                    // access placemark and store it in the following variables
                    // 'guard let else' lets us retrieve optional data and use it within the same scope
                    guard let street = placemark.thoroughfare else { return }
                    guard let postalCode = placemark.postalCode else { return }
                    guard let city = placemark.locality else { return }
                    print("grabbing address")
                    
                    // construct two strings
                    let address = "\(street), "
                    let addressDetail = "\(postalCode), \(city)"
                    
                    // pass them along to the completion block
                    completion(address, addressDetail)
                }
            }
        }
    }
}
