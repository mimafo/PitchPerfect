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
    case initial, recording, record, pausing, paused, stopping, stopped
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
    var state:RecordingState = RecordingState.initial
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeState(RecordingState.initial)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func pausePressed(_ sender: UIButton) {
        
        //First, update UI to pausing state
        changeState(RecordingState.pausing)
        
        //Pause the recording
        audioRecorder.pause();
        
        //Set the state to the paused state
        changeState(RecordingState.paused)
        
    }
    
    @IBAction func resumePressed(_ sender: UIButton) {
        //Disable the recording button first to prevent double tapping
        changeState(RecordingState.recording)
        
        //Now lets start recording sounds
        audioRecorder.record()
        
        //Once recording has started, change the state of the UI
        changeState(RecordingState.record)
    }
    
    @IBAction func stopPressed(_ sender: UIButton) {

        //First, hide the stop button to prevent double tapping
        changeState(RecordingState.stopping)
        
        //Now, Stop the audio recording
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        print("Recording has been stopped")
        
    }
    
    @IBAction func recordAudioPressed(_ sender: UIButton) {
        
        //Disable the recording button first to prevent double tapping
        changeState(RecordingState.recording)
        
        //Now lets start recording sounds
        recordSounds()

        //Once recording has started, change the state of the UI
        changeState(RecordingState.record)
    
        print("In recordAudioPressed")
        
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            
            //Step 1 - save the recorded audio file
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
        
            //Step 2 - Move to the next scene (perform segue)
            performSegue(withIdentifier: "stopRecording", sender: self.recordedAudio)
            
        } else {
            
            print("Recording was not successful")
        
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    fileprivate func recordSounds() {

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        let recordingName = "my_audio"
        //let pathArray = [dirPath, recordingName]
        //let filePath = NSURL; //URL.filePath(pathArray.join())
        //let filePath = URbaseURLRL(withPathComponents: pathArray)
        if let audioFilePath = Bundle.main.path(forResource: recordingName, ofType: "wav", inDirectory: dirPath) {
            print(audioFilePath)
        }
        let filePath = URL(fileURLWithPath: "\(dirPath)/\(recordingName)")
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

    }
    
    fileprivate func changeState(_ state: RecordingState) {
        
        switch state {
        case .initial:
            //Initialize the UI
            stopButton.isHidden = true
            pauseButton.isHidden = true
            resumeButton.isHidden = true
            recordingLabel.text = self.TapInstructionString
            recordButton.isEnabled = true
        case .recording:
            //In the process of Recording
            recordButton.isEnabled = false
        case .record:
            //Record has started
            recordingLabel.text = self.RecordingString
            stopButton.isHidden = false
            pauseButton.isHidden = false
            resumeButton.isHidden = false
            //Enable buttons properly
            pauseButton.isEnabled = true
            resumeButton.isEnabled = false
        case .pausing:
            //In the process of pausing
            pauseButton.isEnabled = false
        case .paused:
            //Record is paused
            recordingLabel.text = self.PauseString
            resumeButton.isEnabled = true
        case .stopping:
            //In the process of stopping the recording
            stopButton.isHidden = true
            pauseButton.isHidden = true
            resumeButton.isHidden = true
        default:
            print("Unhandled case for RecordingState")
        }
        
        self.state = state
        
    }

}

