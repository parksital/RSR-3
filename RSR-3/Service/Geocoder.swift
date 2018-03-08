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
    
    
    // last time and place we successfully fetched
    var timeOfLastFetch = Date()
    var locationOfLastFetch = CLLocation()
    var firstFetch = true   // only true the first time
    var currentAddress = "Streetname, "             // place holder
    var currentSubAddress = "1234 XY, Amsterdam"    // placeholder
    
    //MARK: - Initialization
    override init() {
        super.init()
        print("Geocoder initialized")
    }
    
    //MARK: - Methods
    
    // okay, get ready this method is YUUUGE
    // we are calling this method every time didUpdateLocation gets a new location.
    // didUpdateLocation gets a new location every 2-5 seconds.
    // that's a lot of requests, so let's manage that:
    func tryNewFetchRequestForLocation(_ currentLocation: CLLocation, currentTime: Date) {
        
        // check if this is the first fetch
        if firstFetch {
            
            // set first fetch to false
            self.firstFetch = false
            
            // make the request
            fetchRequestForLocation(currentLocation, completion: { (address, subAddress) in
                
                // this is the completion block.
                // this executes after the fetch
                
                
                // update the time and place of last successful fetch
                self.locationOfLastFetch = currentLocation
                self.timeOfLastFetch = currentTime
                
                // grab the fetched data and store it
                self.currentAddress = address
                self.currentSubAddress = subAddress
                print("Got first address! - updated time and locatin of last fetch")
                           
            })
        } else {
            // for every fetch request after the first
            
            // remember, we do not want to keep fetching.
            
            // we want to know:
            // if the user is within 10 meters of where the last successful fetch request was
            // if the last successful fetch request was 3 minutes ago
            let isWithinRangeOfPreviousLocation = locationOfLastFetch.distance(from: currentLocation) < 10
            let isWithinTimeInterval = currentTime.timeIntervalSince(timeOfLastFetch) < 60 * 3
            
            
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
                fetchRequestForLocation(currentLocation, completion: { (address, subAddress) in
                    self.currentAddress = address
                    self.currentSubAddress = subAddress
                    
                    self.locationOfLastFetch = currentLocation
                    self.timeOfLastFetch = currentTime
                })
                break
            case (false, false):
                // the last successful fetch was longer than 3 minutes ago
                // and the user has traveled more than 10 meter
                
                print("Fetching: Out of range. Out of time - need new fetch")
                fetchRequestForLocation(currentLocation, completion: { (address, subAddress) in
                    self.currentAddress = address
                    self.currentSubAddress = subAddress
                    
                    self.locationOfLastFetch = currentLocation
                    self.timeOfLastFetch = currentTime
                })
                break
            }
        }
    }
    
    
    
    func fetchRequestForLocation(_ location: CLLocation, completion: @escaping (String, String) -> ()) {
        
        // geocoder tries to get string from coordinates
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("we have an error")
                return
            } else {
                
                // if there are placemarks, and there is a placemark at placemarks[0]
                if let placemarks = placemarks, let placemark = placemarks.first {
                    
                    // grab the following data
                    guard let street = placemark.thoroughfare else { return }
                    guard let postalCode = placemark.postalCode else { return }
                    guard let city = placemark.locality else { return }
                    print("grabbing address")
                    
                    // keep it in address and subaddress
                    let address = "\(street), "
                    let subAddress = "\(postalCode), \(city)"
                    
                    // pass it along to the completion block
                    completion(address, subAddress)
                }
            }
        }
    }
}
