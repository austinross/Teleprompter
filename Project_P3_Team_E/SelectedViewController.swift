//
//  SelectedViewController.swift
//  Project_P3_Team_E
//
//  Created by Austin Ross on 10/22/19.
//  Copyright © 2019 Mack Ross. All rights reserved.
//

import UIKit

class SelectedViewController: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var promptName: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    var prompt: Prompt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        promptName.text = prompt?.name
        textView.text = prompt?.text
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 { //Navigation to the SettingsViewController
           if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "presentPrompt" {
           let nextVC = segue.destination as? PresentViewController
           nextVC!.text = prompt?.text
       }
    }

}
