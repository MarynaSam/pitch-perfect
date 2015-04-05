//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Maryna Samushyia on 23/3/15.
//  Copyright (c) 2015 Maryna Samushyia. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var sound:NSURL!
    var receivedAudio:RecordedAudio!
    var engine:AVAudioEngine!
    var myAudioFile:AVAudioFile!
    
    //two more audio players for echo effect
    var echoAudioPlayer1:AVAudioPlayer!
    var echoAudioPlayer2:AVAudioPlayer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        engine = AVAudioEngine()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil);
        
        //init two more AVAudioPlayer objects to create echo effect
        echoAudioPlayer1 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil);
        echoAudioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil);
        
        //init AVAudioFile object for reading or writing
        myAudioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
     
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
        
    }
    
    //play sound slower
    @IBAction func playSlowSound(sender: UIButton) {
        
        self.playingAudioRate(0.5);

    }
    
    //play sound faster
    @IBAction func playFastSound(sender: UIButton) {
        
        self.playingAudioRate(1.5);
        
    }
    
    //function changes the rate of the audio (makes it slower/faster)
    func playingAudioRate(r: Float){
        
        self.stopAnySound()
        
        audioPlayer.enableRate = true
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = r
        audioPlayer.play()
        
    }
    
    //stop playing audio
    @IBAction func stopAnySound(sender: UIButton) {
        
        self.stopAnySound()
        audioPlayer.enableRate = false
        
    }
    
    //Chipmunk effect
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        self.playAudioWithVariablePitch(1000)
        
    }
    
    //Darth Vader effect
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        
        self.playAudioWithVariablePitch(-1000)
        
    }
    
    //fuction changes the pitch of the audio
    func playAudioWithVariablePitch(pitch: Float){

        self.stopAnySound()
        
        //creating sound effect
        engine.reset()
        
        var playerNode = AVAudioPlayerNode()
        engine.attachNode(playerNode)

        var auTimePitch = AVAudioUnitTimePitch()
        auTimePitch.pitch = pitch
        engine.attachNode(auTimePitch)
        engine.connect(playerNode, to: auTimePitch, format: nil)
        engine.connect(auTimePitch, to: engine.outputNode, format: nil)
        
        playerNode.scheduleFile(myAudioFile, atTime: nil, completionHandler: nil)
        engine.startAndReturnError(nil)
        playerNode.play()
        
    }
    
    //echo effect
    @IBAction func playEchoSound(sender: UIButton) {
        
        self.stopAnySound()
        
        echoAudioPlayer1.currentTime = 0.0;
        echoAudioPlayer1.play()
        
        let delay:NSTimeInterval = 0.1//100ms
        var playtime:NSTimeInterval
        playtime = echoAudioPlayer2.deviceCurrentTime + delay
        echoAudioPlayer2.stop()
        echoAudioPlayer2.currentTime = 0.0
        echoAudioPlayer2.volume = 0.8;
        echoAudioPlayer2.playAtTime(playtime)
    }
    
    //function stops any sound to avoid overlapping
    func stopAnySound(){
        
        audioPlayer.stop()
        engine.stop()
        echoAudioPlayer1.stop()
        echoAudioPlayer2.stop()
        
    }

}
