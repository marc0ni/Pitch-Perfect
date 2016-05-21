//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mark Lindamood on 2/8/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var recordingStatus: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    let session = AVAudioSession.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingStatus.hidden = false
        self.recordingStatus.text = "Tap to Record"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecording.hidden = true
        recordButton.enabled = true
        recordingStatus.hidden = false
        self.recordingStatus.text = "Tap to Record"
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        stopRecording.hidden = false
        recordButton.enabled = false
        recordingStatus.hidden = false
        self.recordingStatus.text = "Recording in Progress"
        
        // Record the user's voice
        print("in recordAudio")
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // Setup audio session
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        // Initialize and prepare the recorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            // Save the recorded audio
            let recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            //recordedAudio.filePathUrl = recorder.url
            //recordedAudio.title = recorder.url.lastPathComponent
            
            // Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Recording was not successful")
            recordButton.enabled = true
            stopRecording.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        self.recordingStatus.text = "Recording in Stopped"
        // Stop recording the user's voice
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
    
    
}

