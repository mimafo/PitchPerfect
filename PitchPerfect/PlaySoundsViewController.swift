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

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: self.receivedAudio.filePathUrl)
            audioPlayer.enableRate = true
            
            audioEngine = AVAudioEngine()
            audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
            
            
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
        self.playAudioAt(0.5)
    }
    
    @IBAction func fastPressed(sender: UIButton) {
        print("Fast button pressed");
        self.playAudioAt(2.0)
    }
    
    @IBAction func chipmuckAudioPressed(sender: UIButton) {
        self.playAudioWithVariablePitch(1000)
    }
    
    @IBAction func darthVaderAudioPressed(sender: UIButton) {
        self.playAudioWithVariablePitch(-999)
    }
    
    @IBAction func stopPressed(sender: UIButton) {
        print("Stop button pressed");
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    private func playAudioAt(rate: Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    private func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
}
