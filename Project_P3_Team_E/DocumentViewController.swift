//
//  DocumentViewController.swift
//  Project_P3_Team_E
//
//  Created by Malay on 11/12/19.
//  Copyright © 2019 Mack Ross. All rights reserved.
//

import UIKit
import MobileCoreServices

class DocumentViewController: UIViewController, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var fileName: UITextField!
    
    var fileMgr = FileManager.default
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else{
            return
        }
        print("Import result: \(myURL)")
        
        var tempText = ""
        textArea.text = ""
        do{
            tempText = try String(contentsOf: myURL)
            textArea.text = tempText
            print("==================================")
            print()
        }catch let error as NSError{
            print("Faile to import")
            print(error)
        }
        
        textArea.adjustsFontForContentSizeCategory = true
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document View was Canceled")
        dismiss(animated: true, completion: nil)
    }
    
    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        print("Document view presented")
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func pickDocument(_ sender: Any) {
        print("Entered Menu")
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypeText),String(kUTTypeRTF), String(kUTTypePlainText)], in: .import)
        importMenu.delegate = self
        print("BP1")
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion:nil)
        
        //importMenu.addOption()
        
    }
    
    @IBAction func saveToFile(_ sender: Any) {
        //get file Name
        let fileNameToSave: String = fileName.text!
        
        //temp var to read text in text area
        let content = textArea.text
        
        //file saving location
        
        //directory
        let fileDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = fileDirURL.appendingPathComponent(fileNameToSave).appendingPathExtension("txt")
        
        //writing file l
        do{
            try content?.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            print("success writing")
            print(fileURL)
        }catch let error as NSError{
            print("failed to write")
            print(error)
        }
        
        //save
    }
    
    
    
}


