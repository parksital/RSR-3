//
//  ViewController.swift
//  RSR-3
//
//  Created by Parvin Sital on 05/03/2018.
//  Copyright © 2018 Parvin Sital. All rights reserved.
//

import UIKit

class ViewController: UIViewController {    
    
    //MARK: - Properties
    let sharedInstance = LocationService.sharedInstance

        
    //MARK: - Initialization
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpNavigationBar()
        
        // we do this to hide the nagivation bar, but still utilize the back swipe gestures
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Set Up UI
    func setUpNavigationBar() {
        //set up the back  button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // set up the navigation bar's title
        self.navigationItem.title   = "RSR Revalidatieservice"
    }
    
    //MARK: - IBActions
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) { }

}
