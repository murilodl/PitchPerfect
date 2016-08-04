//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Murilo Della Libera on 14/07/16.
//  Copyright © 2016 murilodl. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController , AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewWillAppear(animated: Bool) {
        stopRecordingButton.enabled = false
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        print("Record Button Pressed")
        
        setUIState(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        
        let recordingName = "recordedVoice.wav"
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
    
    @IBAction func stopRecording(sender: AnyObject) {
        print("stop recording button pressed")
        
        setUIState(false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func setUIState(isRecording:Bool) {
        if isRecording {
            recordButton.enabled = false
            recordingLabel.text = "Recording in Progress"
            stopRecordingButton.enabled = true
        }
        else {
            recordButton.enabled = true
            recordingLabel.text = "Tap to Record"
            stopRecordingButton.enabled = false
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            self.performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}