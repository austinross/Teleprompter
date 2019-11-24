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
    @IBOutlet weak var rButton: UIBarButtonItem!
    @IBOutlet weak var volumeSlider: UISlider!
    
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    var text: String?
    var recordingSession : AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    //change it in segue
    var fName: String = "FileNameRec"
    
    var audioPlayer: AVAudioPlayer?
    var isPlaying: Bool = true
    var timer: Timer?
    //for fastforward and rewind
    var tempTimer: Timer?
    
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
    
    //MARK: - Recording
    @IBAction func volumeSliderAdj(_ sender: Any) {
        print(volumeSlider.value)
        if audioPlayer != nil{
            audioPlayer?.setVolume(volumeSlider.value, fadeDuration: 0.1)
            //audioPlayer?.volume = volumeSlider.value
        }
    }
    func loadRecordingUI(){
        print("Button here")
        //view.addSubview(recordButton)
        rButton.title = "Tap To Record"
        
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
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        do{
            audioRecorder = try AVAudioRecorder(url: audioFileName,settings: settings)
            audioRecorder.delegate = self as? AVAudioRecorderDelegate
            audioRecorder.record()
            
            rButton.title = "Tap to Stop1"
            audioTimer()
        }catch{
            print("error in avaudiorecorder")
            finishRecording(success: false)
        }
    }
    //saving the file
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(paths[0])
        return paths[0]
    }
    //end recording
    func finishRecording(success: Bool){
        audioRecorder.stop()
        audioRecorder = nil
        
        if success{
            rButton.title = "Re-record1"
        }
        else{
            rButton.title = "Record1"
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
        var items = toolbar.items
        //pause
        if (!isPlaying){
            print("Change to Pause")
            items![4] = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.play, target: self, action: #selector(self.playButtonTapped(_:)))
            isPlaying = true
            audioPlayer?.stop()
        }
        //play
        else{
            if audioPlayer == nil{
                playFun()
            }
            audioPlayer?.play()
            print("Change to play")
            items![4] = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.pause, target: self, action: #selector(self.playButtonTapped(_:)))
            
            isPlaying = false
        }
        self.toolbar.setItems(items, animated: true)
        
        
    }
    
    
    @IBAction func ffButtonTapped(_ sender: Any) {
//        tempTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.jumpForward), userInfo: nil, repeats: true)
        if audioPlayer != nil{
            var timeInterval: TimeInterval = audioPlayer!.currentTime
            timeInterval += 5
            if timeInterval > audioPlayer!.duration{
                audioPlayer!.stop()
                print("Stop")
            }
            else{
                
                print(audioPlayer!.currentTime)
                audioPlayer!.currentTime = timeInterval
                if !audioPlayer!.isPlaying{
                    audioPlayer?.play()
                }
            }
        }
        else{
            print("No audio Player")
        }
    }
    
    func playFun(){
        let playFile = getDocumentsDirectory().appendingPathComponent(fName).appendingPathExtension("m4a")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: playFile)
            audioPlayer?.play()
            //volumeSliderAdj(volumeSlider.value)
            print(playFile.relativePath)
        }catch let error as NSError{
            print("Fail to play \(error)")
        }
    }
    
    @IBAction func rewindButtonTapped(_ sender: Any) {
        
        if audioPlayer != nil{
            var timeInterval: TimeInterval = audioPlayer!.currentTime
            timeInterval -= 5
            if timeInterval < 0{
                audioPlayer!.stop()
                print("Stop")
                //need to change button to playbutton
            }
            else{
                
                print(audioPlayer!.currentTime)
                audioPlayer!.currentTime = timeInterval
                if !audioPlayer!.isPlaying{
                    audioPlayer?.play()
                }
            }
        }
        else{
            print("No audio Player")
        }
    }
    
}

//MARK: - Extension

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
