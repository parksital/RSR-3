//
//  MapViewController.swift
//  RSR-3
//
//  Created by Parvin Sital on 05/03/2018.
//  Copyright © 2018 Parvin Sital. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    //MARK: - Properties
    let sharedInstance = LocationService()
    
    //MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpMapView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: - Setup
    func setUpMapView() {
        // get location data
        let userLocation = sharedInstance.location
        let coordinates = userLocation.coordinate
        
        // set zoomlevel and region
        let zoomLevel = MKCoordinateSpanMake(0.02, 0.02)
        let region  = MKCoordinateRegion(center: coordinates, span: zoomLevel)
        
        mapView.setRegion(region, animated: true)
    }
    
    func setUpInitialUI() {
        
        //set the mapview delegate to self
        mapView.delegate = self
        
        // set the navigation bar's title.
        self.navigationItem.title   = "RSR Pechhulp"
        
        // make the belkosten window invisble
//        belKostenWindow.alpha = 0.0
    }
    

    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
}
