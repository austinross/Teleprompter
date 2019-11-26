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
    var isScrolling = false
    @IBOutlet weak var rButton: UIBarButtonItem!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var scrollButtonItem: UIBarButtonItem!
    
    @IBOutlet var audioTimerLabel: UILabel!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    var text: String?
    var recordingSession : AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    //change it in segue
    var fName: String = ""
    
    var audioPlayer: AVAudioPlayer?
    var isRecording: Bool = false
    var isPlaying: Bool = true
    var timer: Timer?
    @objc var recordTimer: Timer?
    //for fastforward and rewind
    var tempTimer: Timer?
    //recordint Timencounter
    var timeCount: Double = 0.0
    
    let defaults = UserDefaults.standard
    var scrollSpeed = 1
    var scrollTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .black
        textView.text = text
        
        var fontSize = defaults.integer(forKey: "fontSize")
        let fontStyle = defaults.string(forKey: "fontStyle") ?? "Arial"
        let fontColor = defaults.string(forKey: "fontColor") ?? "White"
        scrollSpeed = defaults.integer(forKey: "scrollSpeed")
       
        if fontSize == 0 {
            fontSize = 40
            scrollSpeed = 2
        }
        
        textView.font = UIFont(name: fontStyle, size: CGFloat(fontSize))
        textView.textColor = getColor(str: fontColor)
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        recordTimer?.invalidate()
        if audioPlayer != nil{
            audioPlayer = nil
        }
        if audioRecorder != nil{
            finishRecording(success: false)
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
    
    @IBAction func scroll(_ sender: Any) {
        if isScrolling {
            isScrolling = false
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(scroll(_:)))
            timer?.invalidate()
        }
        else {
            isScrolling = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(scroll(_:)))
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(scrollTextView), userInfo: nil, repeats: true)
        }
    }
    
    @objc func scrollTextView() {
        if isScrolling && textView.contentOffset.y < (self.textView.contentSize.height - self.textView.bounds.size.height) {
            let point = CGPoint(x: 0.0, y: (textView.contentOffset.y + CGFloat(10.0 * Double(scrollSpeed))))
            textView.setContentOffset(point, animated: true)
        }
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
            
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter File Name"
            })

            
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { alertPresent -> Void in
                guard let fileNameTextField = alert.textFields?[0] as UITextField?
                else{
                    print("No Name")
                        return
                }
                self.fName = fileNameTextField.text!
                print(fileNameTextField.text)

                
            }))
            alert.addAction(UIAlertAction(title: "Default Name", style: .cancel, handler:
                {
                    (alert: UIAlertAction!) in
                    //pass the file name here.
                    self.fName = "fileNameREC"
                    print(self.fName)
            }))
            self.present(alert, animated: true, completion: nil)
            print(fName)
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
        recordTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PresentViewController.recordT), userInfo: nil, repeats: true)
        timer?.invalidate()
        if audioPlayer != nil{
            recordTimer?.invalidate()
            audioPlayer = nil
        }
        
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
        recordTimer?.invalidate()
        timeCount = 0.0
        //can play audio now
        
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
    //recordT
    @objc func recordT(){
        if timeCount != 0.0{
            timeCount = timeCount + (recordTimer?.timeInterval ?? 0.0)
        }
        else {
            timeCount = Double(recordTimer?.timeInterval ?? 0.0)
        }
        print(timeCount)
        let minutes = Int(timeCount) / 60 % 60
        let seconds = Int(timeCount) % 60
        audioTimerLabel.text = String(format:"%02i:%02i", minutes, seconds)
        print("Recording ON")
    }
    
    //MARK: - AudioPlayer
    @objc func audioTimer(){
        //Timer.scheduledTimer(withTimeInterval: <#T##TimeInterval#>, repeats: <#T##Bool#>, block: <#T##(Timer) -> Void#>)
        let time = Double(audioPlayer?.currentTime ?? 0.0)
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        audioTimerLabel.text = String(format:"%02i:%02i", minutes, seconds)
        print("ON")
        if time == Double(audioPlayer?.duration ?? 0){
            timer?.invalidate()
            print("Clip Finished")
        }
    }
    
    
    @IBAction func playButtonTapped(_ sender: Any) {
        var items = toolbar.items
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PresentViewController.audioTimer), userInfo: nil, repeats: true)
        recordTimer?.invalidate()
        timeCount = 0.0
        //audioTimer()
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
