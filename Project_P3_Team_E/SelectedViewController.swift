//
//  SelectedViewController.swift
//  Project_P3_Team_E
//
//  Created by Austin Ross on 10/22/19.
//  Copyright © 2019 Mack Ross. All rights reserved.
//

import UIKit
import MobileCoreServices

class SelectedViewController: UIViewController, UITabBarDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
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
        switch item.tag {
        case 1: //Export
            //get file Name
            let fileNameToSave: String = promptName.text!
            
            //temp var to read text in text area
            let content = textView.text
            
            //file saving location
            
            //directory
            let fileDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = fileDirURL.appendingPathComponent(fileNameToSave).appendingPathExtension("txt")
            
            //writing file
            do{
                try content?.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
                print("success writing")
                print(fileURL)
            }catch let error as NSError{
                print("failed to write")
                print(error)
            }
        case 2: //Settings
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        default:
            print("Default")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "presentPrompt" {
           let nextVC = segue.destination as? PresentViewController
           nextVC!.text = prompt?.text
       }
    }

}
