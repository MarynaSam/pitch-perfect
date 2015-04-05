//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Maryna Samushyia on 10/3/15.
//  Copyright (c) 2015 Maryna Samushyia. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnMicrophone: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    @IBOutlet weak var btnResume: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad();
        
    }
    
    //prepare the view before showing
    override func viewWillAppear(animated: Bool) {
        
        recordingInProgress.hidden = false;
        recordingInProgress.text = "tap to record"
        btnStop.hidden = true;
        btnMicrophone.enabled = true;
        
        btnPause.hidden = true
        btnResume.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    //pause recording
    @IBAction func pauseRecording(sender: UIButton) {
        
        audioRecorder.pause()
        recordingInProgress.text = "paused"
        
        btnPause.hidden = true
        btnResume.hidden = false

    }
    
    //resume recording
    @IBAction func resumeRecording(sender: UIButton) {
        
        audioRecorder.record()
        recordingInProgress.text = "recording in progress"
        
        btnResume.hidden = true
        btnPause.hidden = false
        
        
    }
    
    //stop recording
    @IBAction func stopRecordingAudio(sender: UIButton) {
        
        btnStop.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        btnMicrophone.enabled = true
        
    }
    
    //record audio
    @IBAction func recordAudio(sender: UIButton){
        
        recordingInProgress.text = "recording in progress"
        btnStop.hidden = false
        btnMicrophone.enabled = false
        
        //???
        btnPause.hidden = false
        
        //create name and file path for the audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        //creating a session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        //recording
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    //passing data to PlaySoundViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stopRecording"){
            
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
        
    }
    
    //when recording finished go to PlaySoundViewController scene via segue identifier
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        if (flag){
            
            recordedAudio = RecordedAudio(filePath: recorder.url, t: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        }
        
    }
}

