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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

    @IBAction func slowPressed(sender: UIButton) {
        print("Slow button pressed");
        self.playAudioWithRate(0.5, pitch: 0)
    }
    
    @IBAction func fastPressed(sender: UIButton) {
        print("Fast button pressed");
        self.playAudioWithRate(2.0, pitch: 0)
    }
    
    @IBAction func chipmuckAudioPressed(sender: UIButton) {
        print("Chipmuck button pressed");
        self.playAudioWithRate(1.0, pitch: 1000)
    }
    
    @IBAction func darthVaderAudioPressed(sender: UIButton) {
        print("Darth Vader button pressed");
        self.playAudioWithRate(1.0, pitch: -1000)
    }
    
    @IBAction func stopPressed(sender: UIButton) {
        print("Stop button pressed");
        self.stopAudioEngine()
    }
    
    private func stopAudioEngine() {
        self.audioEngine.stop()
        self.audioEngine.reset()
    }
    
    private func playAudioWithRate(rate: Float, pitch: Float) {
        self.stopAudioEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        self.audioEngine.attachNode(audioPlayerNode)
        
        //Change the pitch of the audio
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        changePitchEffect.rate = rate
        self.audioEngine.attachNode(changePitchEffect)
        
        self.audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        self.audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! self.audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
}
