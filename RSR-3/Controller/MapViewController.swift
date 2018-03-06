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
    let sharedInstance = LocationService.sharedInstance
    let geocoder = LocationService.sharedInstance.geocoder
    
    //MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var belKostenWindow: UIView!
    @IBOutlet weak var belRSRNuButton: UIButton!
    
    //MARK: - Initialization
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
        belKostenWindow.alpha = 0.0
    }
    
    //MARK: - IBActions
    
    @IBAction func belNuButtonPressed(_ sender: UIButton) {
        let phone = "31204002679"
        
        if let url = NSURL(string: "tel://\(phone)") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func belRSRButtonPressed(_ sender: UIButton) {
        // make annotation callout disappear
        
        UIView.animate(withDuration: 0.5, animations: {
            self.belKostenWindow.alpha = 1.0    //make belKostenWindow appear
            sender.alpha = 0.0      // make sender button disappear
        })
    }
    
    @IBAction func annulerenButtonPressed(_ sender: UIButton) {
        //make annotation callout re-apear
        
        UIView.animate(withDuration: 0.5, animations: {
            self.belKostenWindow.alpha  = 0.0   //make belKostenWindow disappear
            self.belRSRNuButton.alpha   = 1.0   //make sender button re-appear
        })
    }
}

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            // we need the user location annotation
            return nil
        } else {
            // set up a re-use identifier
            let reuseId = "pinIdentifier"
            
            // create a MKPinAnnotationView
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            // customize the pin
            pinView.canShowCallout  = false
            pinView.pinTintColor    = .red
            
            // add custom callout here
            if let addressView = Bundle.main.loadNibNamed("AddressWindowView", owner: self, options: nil)?.first as? AddressWindowView {
                
                var calloutViewFrame = addressView.frame
                
                // I had to hardcode this, feels bad man
                calloutViewFrame.origin = CGPoint(x: -calloutViewFrame.size.width / 2 + 15, y: -calloutViewFrame.size.height)
                addressView.frame = calloutViewFrame
                pinView.addSubview(addressView)
            }
            
            // return the pin
            return pinView
        }
    }
}
