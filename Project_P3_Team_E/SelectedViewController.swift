//
//  SelectedViewController.swift
//  Project_P3_Team_E
//
//  Created by Austin Ross on 10/22/19.
//  Copyright © 2019 Mack Ross. All rights reserved.
//

import UIKit
import MobileCoreServices
import RealmSwift
import WebKit
import PDFKit

extension SelectedViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}

class SelectedViewController: UIViewController, UITabBarDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var promptName: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var edit: UITabBarItem!
    @IBOutlet weak var export: UITabBarItem!
    @IBOutlet weak var settings: UITabBarItem!
    @IBOutlet weak var delete: UITabBarItem!
    
    var prompt: Prompt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        promptName.text = prompt?.name
        textView.text = prompt?.text
        textView.delegate = self
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0: //Edit
            //Save old text in case the user doesn't want the changes
            
            //Check if text is already being edited
            if textView.isEditable == false {
                textView.isEditable = true
                textView.becomeFirstResponder()
            }
            else {
                textView.isEditable = false
                let alert = UIAlertController(title: "Would you like to save your changes?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    self.savePrompt()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                        let realm = try! Realm()
                    let oldPrompt = realm.objects(Prompt.self).filter("name = '\(self.promptName.text ?? "")'").first
                    self.textView.text = oldPrompt?.text
                }))
                self.present(alert, animated: true)
            }
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
            let alert = UIAlertController(title: "\(prompt!.name) has been exported!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        case 2: //Settings
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
                if let navigator = navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        case 3: //Delete
            let alert = UIAlertController(title: "Are you sure you want to delete your prompt?", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                let realm = try! Realm()
                let prompt = realm.objects(Prompt.self).filter("name = '\(self.promptName.text ?? "")'").first
                try! realm.write {
                    realm.delete(prompt!)
                }
                self.navigationController?.popViewController(animated: true)
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        default:
            print("Default")
        }
    }

    func savePrompt() {
        if promptName.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter a name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if textView.text == "" {
            let alert = UIAlertController(title: "Error", message: "Please enter text", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let promptDate = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .short)
        
        let prompt = Prompt(name: promptName.text!, date: promptDate, text: textView.text!)
        let realm = try! Realm()
        try! realm.write {
            realm.add(prompt)
            print("Added prompt \(prompt.name) to Realm.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "presentPrompt" {
           let nextVC = segue.destination as? PresentViewController
           nextVC!.text = prompt?.text
       }
    }
}
