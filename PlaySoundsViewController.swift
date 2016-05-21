//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mark Lindamood on 2/9/16.
//  Copyright © 2016 udacity. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
   
    @IBOutlet weak var stopPlayback: UIBarButtonItem!
    @IBOutlet weak var pausePlayback: UIBarButtonItem!
    @IBOutlet weak var playPlayback: UIBarButtonItem!

    
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var nowPlaying = false
    var timer:NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        do {
            try audioPlayer =  AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        } catch {
            print("error")
        }
        audioPlayer!.prepareToPlay()
        audioPlayer!.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayCurrentTime() {
        
    }
    
    //
    /* Mark -- Buttons, refactoring copied from https://swiftios8dev.wordpress.com/2015/03/05/sound-effects-using-avaudioengine/
    
    This code replaced a similar, less refactored code from https://github.com/mike-holcomb/pitch-perfect/blob/master/PlaySoundsViewController.swift
    */
    
    
    @IBAction func playSlowAudio(sender: UIButton) {
        commonAudioFunction(0.5, typeOfChange: "rate")
        print("playing slow audio")
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        commonAudioFunction(1.5, typeOfChange: "rate")
        print("playing fast audio")
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        commonAudioFunction(1000, typeOfChange: "pitch")
        print("playing high audio")
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        commonAudioFunction(-1000, typeOfChange: "pitch")
        print("playing low audio")
    }
    
    
    //
    //Mark -- Effect Functions
    //
    
    //Copied from: https://swiftios8dev.wordpress.com/2015/03/05/sound-effects-using-avaudioengine/ in order to provide 'typeOfChange' properties to 'play...Audio' functions
    
    func commonAudioFunction(audioChangeNumber: Float, typeOfChange: String){
        let audioPlayerNode = AVAudioPlayerNode()
        
        stopAudioPlayback()
        
        audioEngine.attachNode(audioPlayerNode)
        
        let changeAudioUnitTime = AVAudioUnitTimePitch()
        
        if (typeOfChange == "rate") {
            
            changeAudioUnitTime.rate = audioChangeNumber
            
        } else {
            changeAudioUnitTime.pitch = audioChangeNumber
        }
        audioEngine.attachNode(changeAudioUnitTime)
        audioEngine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        audioEngine.connect(changeAudioUnitTime, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    //
    //MARK: -- Operations Functions
    //
    
       // Copied from https://github.com/mike-holcomb/pitch-perfect/blob/master/PlaySoundsViewController.swift ///
    func stopAudioPlayback(){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func stopButtonAction(sender: UIBarButtonItem) {
        stopAudioPlayback()
        audioPlayer.currentTime = 0.0
    }
    
    
    // Modified from http://www.xcode-training-and-tips.com/avaudioplayer-play-sound-in-an-app-in-xcode/
    @IBAction func playButtonAction(sender: UIBarButtonItem) {
        if !nowPlaying {
            audioPlayer.play()
            nowPlaying = true
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "displayCurrentTime", userInfo: nil, repeats: true)
        }
    }
    
    // action - pause button
    @IBAction func pauseButtonAction(sender: UIBarButtonItem) {
        if nowPlaying {
            audioPlayer.pause()
            nowPlaying = false
        }
        
    }
    
}
    

