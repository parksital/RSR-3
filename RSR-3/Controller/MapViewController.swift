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
    
    //MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var belKostenWindow: UIView!
    @IBOutlet weak var belRSRNuButton: UIButton!
    
    //address window view outlets
    @IBOutlet var addressWindowView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var subAddressLabel: UILabel!
    
    
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpInitialUI()
        
        Timer.scheduledTimer(timeInterval: 12.0, target: self, selector: #selector(updateAddressLabels), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        centerMapView()
        checkAuthorizationStatus()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Setup
    private func centerMapView() {
        // get optional location
        if let userLocation = LocationService.sharedInstance.location {
            
            // set coordinates and zoom level 
            let coordinates = userLocation.coordinate
            let zoomLevel = MKCoordinateSpanMake(0.02, 0.02)
            let region  = MKCoordinateRegion(center: coordinates, span: zoomLevel)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func setUpInitialUI() {
        mapView.delegate = self //set the mapview delegate to self
        self.navigationItem.title   = "RSR Pechhulp"    // set the navigation bar's title.
        belKostenWindow.alpha = 0.0     // make the belkosten window invisble
        
        setUpAddressWindowView()
        }
    
    private func setUpAddressWindowView() {
        var calloutViewFrame = addressWindowView.frame
        
        // I had to hardcode this, feels bad man :(
        calloutViewFrame.origin = CGPoint(x: -calloutViewFrame.size.width / 2 + 15, y: -calloutViewFrame.size.height)
        addressWindowView.frame = calloutViewFrame
    }
    
    @objc private func updateAddressLabels() {
        let address = LocationService.sharedInstance.geocoder.currentAddress
        let subAddress = LocationService.sharedInstance.geocoder.currentAddressDetail
        
        addressLabel.text = address
        subAddressLabel.text = subAddress
        print("address labels updated.")
    }
    
    
    private func presentAlert() {
        let alertTitle      = "GPS aanzetten"
        let alertMessage    = "U heeft deze app geen toegang gegeven voor GPS. Zet dit a.u.b. aan in uw instellingen"
        
        let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertView.addAction(alertOkAction)
        present(alertView, animated: true, completion: nil)
    }
    
    //MARK: - Helper methods
    private func checkAuthorizationStatus() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        // checking the authorization before presenting the map
        switch authorizationStatus {
        case .denied:
            // the user has denied authorization, show an alert.
            presentAlert()
        case .restricted:
            // the user's device is restricted, show an alert.
            presentAlert()
        default:
            break
        }
    }
    
    //MARK: - IBActions
    @IBAction func belNuButtonPressed(_ sender: UIButton) {
        let phone = "319007788990"
        
        if let url = NSURL(string: "tel://\(phone)") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func belRSRButtonPressed(_ sender: UIButton) {
        // make annotation callout disappear
        UIView.animate(withDuration: 0.5, animations: {
            self.belKostenWindow.alpha = 1.0    //make belKostenWindow appear
            self.addressWindowView.alpha = 0.0  // make address window disappear
            sender.alpha = 0.0      // make sender button disappear
        })
    }
    
    @IBAction func annulerenButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.belKostenWindow.alpha  = 0.0   //make belKostenWindow disappear
            self.addressWindowView.alpha = 1.0  // make address window re-appear
            self.belRSRNuButton.alpha   = 1.0   //make sender button re-appear
        })
    }
}

extension MapViewController: MKMapViewDelegate {
    
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKUserLocation) {
            // we need the user location annotation
            return nil
        } else {
            
            var pinView = MKAnnotationView()
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                pinView = returniPadPinForAnnotation(annotation)
            } else if UIDevice.current.userInterfaceIdiom == .phone {
                pinView = returniPhonePinForAnnotation(annotation)
            }
            
            return pinView
        }
    }
    
    internal func returniPhonePinForAnnotation(_ annotation: MKAnnotation) -> MKAnnotationView {
        // set up a re-use identifier
        let reuseId = "pinIdentifier"
        
        // create a MKPinAnnotationView
        let pinViewForPhone = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        
        // customize the pin
        pinViewForPhone.canShowCallout  = false
        pinViewForPhone.pinTintColor    = .red
        
        pinViewForPhone.addSubview(addressWindowView)
        
        // return the pin
        return pinViewForPhone
    }
    
    internal func returniPadPinForAnnotation(_ annotation: MKAnnotation) -> MKAnnotationView {
        let reuseIdForPad = "iPadPinIdentifier"
        
        let pinViewForPad = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdForPad)
        
        pinViewForPad.canShowCallout = false
        pinViewForPad.image = UIImage(named: "marker")
        pinViewForPad.addSubview(addressWindowView)
        
        return pinViewForPad
    }
    
}
