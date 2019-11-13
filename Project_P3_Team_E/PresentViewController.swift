//
//  PresentViewController.swift
//  Project_P3_Team_E
//
//  Created by Austin Ross on 10/22/19.
//  Copyright © 2019 Mack Ross. All rights reserved.
//

import UIKit

class PresentViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        textView.text = text
    }
    
    @IBAction func exit(_ sender: Any) {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func mirrorX(_ sender: Any) {
        textView.flipY()
    }
    
    @IBAction func mirrorY(_ sender: Any) {
        textView.flipX()
    }
    
}

extension UIView {
   /// Flip view horizontally.
   func flipX() {
       transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
   }

   /// Flip view vertically.
   func flipY() {
       transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
   }
}
