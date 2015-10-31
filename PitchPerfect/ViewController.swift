//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Michael Folcher on 10/27/15.
//  Copyright © 2015 Mimafo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.stopButton.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func stopPressed(sender: UIButton) {
        //Change UI to that the stop button and recording label are hidden, and the recording button is enabled
        self.recordingLabel.hidden = true
        self.recordButton.enabled = true
        self.stopButton.hidden = true
        
        print("Recording has been stopped")
    }
    
    @IBAction func recordAudioPressed(sender: UIButton) {
        //Change UI to that the stop button and recording label are visible, and the recording button is disabled
        self.recordingLabel.hidden = false
        self.recordButton.enabled = false
        self.stopButton.hidden = false
        
        //TODO: Record the user's voice
        print("In recordAudioPressed")
        
        
    }
}

