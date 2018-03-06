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
    
    //MARK: - IBOutlets
    
        
    //MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        
        
    }
    
    //MARK: - Set Up UI
    func setUpNavigationBar() {
        //set up the back  button
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // set up the navigation bar's title
        self.navigationItem.title   = "RSR Revalidatieservice"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBActions
}
