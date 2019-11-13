//
//  CreationViewController.swift
//  Project_P3_Team_E
//
//  Created by Austin Ross on 10/22/19.
//  Copyright © 2019 Mack Ross. All rights reserved.
//

import UIKit
import RealmSwift
import MobileCoreServices

class CreationViewController: UIViewController, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func save(_ sender: Any) {
        savePrompt()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func importPrompt(_ sender: Any) {
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeText),String(kUTTypeRTF), String(kUTTypePlainText)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion:nil)
    }
    
    func savePrompt() {
        if nameTextField.text == "" {
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
        
        let prompt = Prompt(name: nameTextField.text!, date: promptDate, text: textView.text!)
        let realm = try! Realm()
        try! realm.write {
            realm.add(prompt)
            print("Added prompt \(prompt.name) to Realm.")
        }
    }
    
}
