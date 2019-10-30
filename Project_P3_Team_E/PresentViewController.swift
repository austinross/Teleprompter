//
//  PresentViewController.swift
//  Project_P3_Team_E
//
//  Created by Austin Ross on 10/22/19.
//  Copyright © 2019 Mack Ross. All rights reserved.
//

import UIKit

class PresentViewController: UIViewController {

    @IBAction func exit(_ sender: Any) {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        // Do any additional setup after loading the view.
    }

}
