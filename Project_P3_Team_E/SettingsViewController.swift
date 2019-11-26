//
//  SettingsViewController.swift
//  Project_P3_Team_E
//
//  Created by Austin Ross on 10/22/19.
//  Copyright © 2019 Mack Ross. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var exampleLabel: UILabel!
    
    @IBOutlet weak var fontSizeTextField: UITextField!
    var fontSizes = ["1","2","3","4","5","6","7","8","9","10"]
    
    @IBOutlet weak var fontStyleTextField: UITextField!
    var fontStyles = ["Arial", "Helvetica", "Times New Roman"]
    
    @IBOutlet weak var fontColorTextField: UITextField!
    var fontColors = ["White", "Blue", "Red", "Green", "Yellow"]
    
    @IBOutlet weak var scrollSpeedTextField: UITextField!
    var scrollSpeeds = ["x1","x2","x3","x4","x5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        let fontSize = defaults.integer(forKey: "fontSize")
        let fontStyle = defaults.string(forKey: "fontStyle")
        let fontColor = defaults.string(forKey: "fontColor")
        let scrollSpeed = defaults.integer(forKey: "scrollSpeed")
        
        exampleLabel.font = UIFont(name: fontStyle ?? "Arial", size: CGFloat(fontSize))
        exampleLabel.textColor = getColor(str: fontColor!)
        
        let fontSizePickerView = UIPickerView()
        fontSizePickerView.delegate = self
        fontSizePickerView.tag = 0
        fontSizeTextField.inputView = fontSizePickerView
        fontSizeTextField.text = String(fontSize/10)
        
        let fontStylePickerView = UIPickerView()
        fontStylePickerView.delegate = self
        fontStylePickerView.tag = 1
        fontStyleTextField.inputView = fontStylePickerView
        fontStyleTextField.text = fontStyle
        
        let fontColorPickerView = UIPickerView()
        fontColorPickerView.delegate = self
        fontColorPickerView.tag = 2
        fontColorTextField.inputView = fontColorPickerView
        fontColorTextField.text = fontColor
        
        let scrollSpeedPickerView = UIPickerView()
        scrollSpeedPickerView.delegate = self
        scrollSpeedPickerView.tag = 3
        scrollSpeedTextField.inputView = scrollSpeedPickerView
        scrollSpeedTextField.text = "x"+String(scrollSpeed)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return fontSizes.count
        case 1:
            return fontStyles.count
        case 2:
            return fontColors.count
        case 3:
            return scrollSpeeds.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return fontSizes[row]
        case 1:
            return fontStyles[row]
        case 2:
            return fontColors[row]
        case 3:
            return scrollSpeeds[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            fontSizeTextField.text = fontSizes[row]
            var size : CGFloat = Double(fontSizes[row]).map{ CGFloat($0) }!
            size = size * CGFloat(10)
            let font = UIFont(name: exampleLabel.font.fontName, size: size)
            exampleLabel.font = font
            defaults.set(size, forKey: "fontSize")
        case 1:
            fontStyleTextField.text = fontStyles[row]
            var size : CGFloat = Double(fontSizeTextField.text!).map{ CGFloat($0) }!
            size = size * CGFloat(10)
            let font = UIFont(name: fontStyles[row], size: size)
            exampleLabel.font = font
            defaults.set(fontStyles[row], forKey: "fontStyle")
        case 2:
            fontColorTextField.text = fontColors[row]
            let color = getColor(str: fontColors[row])
            exampleLabel.textColor = color
            defaults.set(fontColors[row], forKey: "fontColor")
        case 3:
            scrollSpeedTextField.text = scrollSpeeds[row]
            let speed = Int(String(Array(scrollSpeeds[row])[1]))
            defaults.set(speed, forKey: "scrollSpeed")
        default:
            print("Default")
        }
    }
}

public extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getColor(str: String) -> UIColor {
        switch str {
        case "White":
            return UIColor.white
        case "Blue":
            return UIColor.blue
        case "Red":
            return UIColor.red
        case "Green":
            return UIColor.green
        case "Orange":
            return UIColor.orange
        case "Yellow":
            return UIColor.yellow
        default:
            return UIColor.white
        }
    }
}
