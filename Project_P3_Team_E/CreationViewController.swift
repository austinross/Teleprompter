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
import WebKit
import PDFKit

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
    
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else{
            return
        }
        print("Import result: \(myURL)")
        

        var tempText = ""
        textView.text = ""
        //file name :- /directory/fileName
        let  fileName = myURL.deletingPathExtension().lastPathComponent
        print(fileName)
        do{
            tempText = try String(contentsOf: myURL)
            textView.text = tempText
        }catch let error as NSError{
            print("Faile to import")
            print(error)
        }
        
        if nameTextField.text == ""{
            nameTextField.text = myURL.deletingPathExtension().lastPathComponent
        }
        
        
        //MARK: - PDF import
        
        if myURL.pathExtension == "pdf"{
            //let webView = WKWebView(frame: view.frame)
            //let urlRequest = URLRequest(url: myURL)
            //webView.load(urlRequest)
            //view.addSubview(webView)
            
            
            //PDFKit
            if let pdf = PDFDocument(url: myURL){
                let pageCount = pdf.pageCount
                let documentContent = NSMutableAttributedString()
                
                for i in 1..<pageCount{
                    guard let page = pdf.page(at: i) else{continue}
                    guard let pageContent = page.attributedString else{continue}
                    documentContent.append(pageContent)
                }
                print(documentContent)
                textView.attributedText = documentContent
            }
        }
            

        textView.adjustsFontForContentSizeCategory = true
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document View was Canceled")
        dismiss(animated: true, completion: nil)
    }
    
    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        print("Document view presented")
        present(documentPicker, animated: true, completion: nil)
    }
}
