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
    // last time and place we successfully fetched
    var timeOfLastFetch = Date()
    var locationOfLastFetch = CLLocation()
    
    override init() {
        super.init()
    }
    
    func newFetchRequestAtLocation(_ currentLocation: CLLocation, currentTime: Date) {
        
        let oneMinuteInterval = 60.0
        let isWithinRangeOfLastFetchLocation = currentLocation.distance(from: locationOfLastFetch) < 10.0
        let isWithinTimeIntervalOfLastFetchTime = currentTime.timeIntervalSince(timeOfLastFetch) < oneMinuteInterval * 3
        
        if isWithinRangeOfLastFetchLocation || isWithinTimeIntervalOfLastFetchTime {
            // no fetch
        } else {
            //fetch!!
            
            self.timeOfLastFetch = currentTime
            self.locationOfLastFetch = currentLocation
        }
    }
    
/*
    func makeGeocodeReverseRequest(completion: @escaping (String, String) -> ()) {
        
        let latitude = self.coordinate.latitude
        let longitude = self.coordinate.longitude
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print("we have an error")
                return
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    
                    guard let address = placemark.thoroughfare else { return }
                    guard let addressNumber = placemark.subThoroughfare else { return }
                    guard let postalCode = placemark.postalCode else { return }
                    guard let city = placemark.locality else { return }
                    
                    let internalTitle = "\(address) \(addressNumber), "
                    let internalSubtitle = "\(postalCode), \(city)"
                    
                    completion(internalTitle, internalSubtitle)
                }
            }
        }
    }
 */
}
