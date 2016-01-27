//
//  TouchIDViewController.swift
//  JGFLabRoom
//
//  Created by Josep González on 27/1/16.
//  Copyright © 2016 Josep Gonzalez Fernandez. All rights reserved.
//

import UIKit

class TouchIDViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    private func setupController() {
        Utils.cleanBackButtonTitle(navigationController)
    }
}
