//
//  PresentViewController.swift
//  Project_P3_Team_E
//
//  Created by Austin Ross on 10/22/19.
//  Copyright © 2019 Mack Ross. All rights reserved.
//

import UIKit
import AVFoundation

class PresentViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var rButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var text: String?
    var recordingSession : AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    //change it in segue
    var fName: String = "FileNameRec"
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        textView.text = text
        
        
        recordingSession = AVAudioSession.sharedInstance()
        do{
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {[unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed{
                        self.loadRecordingUI()
                        print("Loaded button")
                    }
                    else{
                        print("Can't record")
                    }
                }
            }
        }catch let error as NSError{
            print(error)
        }
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
    
    
    @IBAction func volumeSliderAdj(_ sender: Any) {
        if audioPlayer != nil{
            audioPlayer?.volume = volumeSlider.value
        }
    }
    func loadRecordingUI(){
        print("Button here")
        //view.addSubview(recordButton)
        rButton.setTitle("Tap To Record1", for: .normal)
        
    }
    //Record Button Tapped
    @IBAction func audioRecord(_ sender: Any) {
        if fName == ""{
            let alert = UIAlertController(title: "FileName", message: "Give file a Name or default 'textfileName'Rec will be used", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Default Name", style: .default, handler:
                {
                    (alert: UIAlertAction!) in
                    //pass the file name here.
                    self.fName = "fileNameREC"
                    print(self.fName)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if audioRecorder != nil{
            finishRecording(success: true)
        }
        else{
            startRecording()
        }
        //startRecording()
    }
    
    
    func startRecording(){
        print("Recording Audoi")
        
        let audioFileName = getDocumentsDirectory().appendingPathComponent(fName).appendingPathExtension("m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey : 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do{
            audioRecorder = try AVAudioRecorder(url: audioFileName,settings: settings)
            audioRecorder.delegate = self as? AVAudioRecorderDelegate
            audioRecorder.record()
            
            rButton.setTitle("Tap to Stop1", for: .normal)
            audioTimer()
        }catch{
            print("error in avaudiorecorder")
            finishRecording(success: false)
        }
    }
    //saving the file
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    //end recording
    func finishRecording(success: Bool){
        audioRecorder.stop()
        audioRecorder = nil
        
        if success{
            rButton.setTitle("Re-record1", for: .normal)
        }
        else{
            rButton.setTitle("Record1", for: .normal )
        }
        
    }
    //unexpected ending of recording
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    //TODO
    func audioTimer(){
        //Timer.scheduledTimer(withTimeInterval: <#T##TimeInterval#>, repeats: <#T##Bool#>, block: <#T##(Timer) -> Void#>)
    }
    
    
    @IBAction func playButtonTapped(_ sender: Any) {
        let playFile = getDocumentsDirectory().appendingPathComponent(fName).appendingPathExtension("m4a")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: playFile)
            audioPlayer?.play()
            volumeSliderAdj(volumeSlider.value)
            
        }catch let error as NSError{
            print("Fail to play \(error)")
        }
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
