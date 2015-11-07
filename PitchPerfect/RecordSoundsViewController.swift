//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Michael Folcher on 10/27/15.
//  Copyright © 2015 Mimafo. All rights reserved.
//

import UIKit
import AVFoundation

enum RecordingState {
    case Initial, Recording, Record, Pausing, Paused, Stopping, Stopped
}

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    let RecordingString = "Recording"
    let TapInstructionString = "Tap to Record"
    let PauseString = "Paused"
    
    //Declared Globally
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var state:RecordingState = RecordingState.Initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        changeState(RecordingState.Initial)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func pausePressed(sender: UIButton) {
        
        //First, update UI to pausing state
        changeState(RecordingState.Pausing)
        
        //Pause the recording
        audioRecorder.pause();
        
        //Set the state to the paused state
        changeState(RecordingState.Paused)
        
    }
    
    @IBAction func resumePressed(sender: UIButton) {
        //Disable the recording button first to prevent double tapping
        changeState(RecordingState.Recording)
        
        //Now lets start recording sounds
        audioRecorder.record()
        
        //Once recording has started, change the state of the UI
        changeState(RecordingState.Record)
    }
    
    @IBAction func stopPressed(sender: UIButton) {

        //First, hide the stop button to prevent double tapping
        changeState(RecordingState.Stopping)
        
        //Now, Stop the audio recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        print("Recording has been stopped")
        
    }
    
    @IBAction func recordAudioPressed(sender: UIButton) {
        
        //Disable the recording button first to prevent double tapping
        changeState(RecordingState.Recording)
        
        //Now lets start recording sounds
        recordSounds()

        //Once recording has started, change the state of the UI
        changeState(RecordingState.Record)
    
        print("In recordAudioPressed")
        
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            
            //Step 1 - save the recorded audio file
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
            //Step 2 - Move to the next scene (perform segue)
            performSegueWithIdentifier("stopRecording", sender: self.recordedAudio)
            
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
    
    private func changeState(state: RecordingState) {
        
        switch state {
        case .Initial:
            //Initialize the UI
            stopButton.hidden = true
            pauseButton.hidden = true
            resumeButton.hidden = true
            recordingLabel.text = self.TapInstructionString
            recordButton.enabled = true
        case .Recording:
            //In the process of Recording
            recordButton.enabled = false
        case .Record:
            //Record has started
            recordingLabel.text = self.RecordingString
            stopButton.hidden = false
            pauseButton.hidden = false
            resumeButton.hidden = false
            //Enable buttons properly
            pauseButton.enabled = true
            resumeButton.enabled = false
        case .Pausing:
            //In the process of pausing
            pauseButton.enabled = false
        case .Paused:
            //Record is paused
            recordingLabel.text = self.PauseString
            resumeButton.enabled = true
        case .Stopping:
            //In the process of stopping the recording
            stopButton.hidden = true
            pauseButton.hidden = true
            resumeButton.hidden = true
        default:
            print("Unhandled case for RecordingState")
        }
        
        self.state = state
        
    }

}

