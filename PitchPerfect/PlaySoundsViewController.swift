//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Michael Folcher on 10/30/15.
//  Copyright © 2015 Mimafo. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            
            audioEngine = AVAudioEngine()
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
            
            let session = AVAudioSession.sharedInstance()
            try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            
            
        } catch {
            print("Audio file could not be initialized")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func slowPressed(_ sender: UIButton) {
        print("Slow button pressed");
        playAudioWithRate(0.5, pitch: 0)
    }
    
    @IBAction func fastPressed(_ sender: UIButton) {
        print("Fast button pressed");
        playAudioWithRate(2.0, pitch: 0)
    }
    
    @IBAction func chipmuckAudioPressed(_ sender: UIButton) {
        print("Chipmuck button pressed");
        playAudioWithRate(1.0, pitch: 1000)
    }
    
    @IBAction func darthVaderAudioPressed(_ sender: UIButton) {
        print("Darth Vader button pressed");
        playAudioWithRate(1.0, pitch: -1000)
    }
    
    @IBAction func stopPressed(_ sender: UIButton) {
        print("Stop button pressed");
        stopAudioEngine()
    }
    
    fileprivate func stopAudioEngine() {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    fileprivate func playAudioWithRate(_ rate: Float, pitch: Float) {
        stopAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        //Change the pitch of the audio
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        changePitchEffect.rate = rate
        audioEngine.attach(changePitchEffect)
        
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
}
