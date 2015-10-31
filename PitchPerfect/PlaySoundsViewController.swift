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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
            
            let filePathUrl = NSURL.fileURLWithPath(filePath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOfURL: filePathUrl)
                audioPlayer.enableRate = true
            } catch {
                print("Error building audioPlayer")
            }
            
            
        } else {
            print("The filePath is empty!")
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
    
    @IBAction func stopPressed(sender: UIButton) {
        print("Stop button pressed");
        audioPlayer.stop()
    }
    
    private func playAudioAt(rate: Float) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
}
