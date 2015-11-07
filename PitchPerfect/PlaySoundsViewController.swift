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
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl)
            
        } catch {
            print("Audio file could not be initialized")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func slowPressed(sender: UIButton) {
        print("Slow button pressed");
        playAudioWithRate(0.5, pitch: 0)
    }
    
    @IBAction func fastPressed(sender: UIButton) {
        print("Fast button pressed");
        playAudioWithRate(2.0, pitch: 0)
    }
    
    @IBAction func chipmuckAudioPressed(sender: UIButton) {
        print("Chipmuck button pressed");
        playAudioWithRate(1.0, pitch: 1000)
    }
    
    @IBAction func darthVaderAudioPressed(sender: UIButton) {
        print("Darth Vader button pressed");
        playAudioWithRate(1.0, pitch: -1000)
    }
    
    @IBAction func stopPressed(sender: UIButton) {
        print("Stop button pressed");
        stopAudioEngine()
    }
    
    private func stopAudioEngine() {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    private func playAudioWithRate(rate: Float, pitch: Float) {
        stopAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        //Change the pitch of the audio
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        changePitchEffect.rate = rate
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
}
