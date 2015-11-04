//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Michael Folcher on 10/27/15.
//  Copyright © 2015 Mimafo. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    let RecordingString = "Recording..."
    let TapInstructionString = "Tap to Record"
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.stopButton.hidden = true;
        self.recordingLabel.text = self.TapInstructionString
        self.recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func stopPressed(sender: UIButton) {

        //First, hide the stop button to prevent double tapping
        self.stopButton.hidden = true
        
        //Now, Stop the audio recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        print("Recording has been stopped")
        
    }
    
    @IBAction func recordAudioPressed(sender: UIButton) {
        
        //Disable the recording button first to prevent double tapping
        self.recordButton.enabled = false
        
        //Now lets start recording sounds
        self.recordSounds()

        //Once recording has started, display the recording string and stop button
        self.recordingLabel.text = self.RecordingString
        self.stopButton.hidden = false
    
        print("In recordAudioPressed")
        
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            
            //Step 1 - save the recorded audio file
            self.recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
            //Step 2 - Move to the next scene (perform segue)
            self.performSegueWithIdentifier("stopRecording", sender: self.recordedAudio)
            
        } else {
            
            print("Recording was not successful")
        
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    private func recordSounds() {

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }

}

