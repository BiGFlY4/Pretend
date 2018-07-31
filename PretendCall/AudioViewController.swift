//
//  AudioViewController.swift
//  PretendCall
//
//  Created by Jifei sui on 2018/6/20.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftSiriWaveformView

class AudioViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    weak var timer: Timer?
    var soundFileURL: URL?
    var sourceName: String?
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var isAudioPlayer: Bool = false
    let timerInterval = 0.01
    
    @IBOutlet weak var waveView: SwiftSiriWaveformView!
    @IBOutlet weak var audioTime: UILabel!
    @IBOutlet weak var holdRecord: UIButton!
    @IBOutlet weak var play: UIButton!
    
    func format(duration: TimeInterval) -> String {
        let interval = Int(duration.rounded())
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func createAudioPlayer() {
        do {
            audioPlayer =  try AVAudioPlayer(contentsOf: soundFileURL!)
            audioPlayer?.isMeteringEnabled = true
            audioTime.text = format(duration: (audioPlayer?.currentTime)!) + "/" + format(duration: (audioPlayer?.duration)!)
            isAudioPlayer = true
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func createAudioRecorder() {
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        soundFileURL = dirPaths[0].appendingPathComponent(sourceName! + ".aif")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeVoiceChat)
            try audioRecorder = AVAudioRecorder(url: soundFileURL!, settings: recordSettings as [String : AnyObject])
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func holdRecordTouchDown(_ sender: UIButton) {
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(updateAudioRecordProgressView), userInfo: nil, repeats: true)
        audioRecorder?.record()
        play.isEnabled = false
    }
    
    @IBAction func holdRecordTouchUp(_ sender: UIButton) {
        audioRecorder?.stop()
    }
    
    @IBAction func holdRecordTouchUpOutside(_ sender: UIButton) {
        audioRecorder?.stop()
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        if sender.currentTitle == "Play" {
            UIDevice.current.isProximityMonitoringEnabled = true
            timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(updateAudioPlayProgressView), userInfo: nil, repeats: true)
            holdRecord.isEnabled = false
            audioPlayer?.play()
            sender.setTitle("Stop", for: .normal)
            sender.setImage(UIImage(named: "Pause.png"), for: .normal)
        }
        else if sender.currentTitle == "Stop" {
            UIDevice.current.isProximityMonitoringEnabled = false
            audioPlayer?.stop()
            audioPlayer?.currentTime = 0.0
            holdRecord.isEnabled = true
            sender.setTitle("Play", for: .normal)
            sender.setImage(UIImage(named: "Play.png"), for: .normal)
        }
    }
    
    @objc func updateAudioPlayProgressView()
    {
        audioTime.text = format(duration: (audioPlayer?.currentTime)!) + "/" + format(duration: (audioPlayer?.duration)!)
        audioPlayer?.updateMeters()
        let averagePower = audioPlayer?.averagePower(forChannel: 0)
        let percentage = (averagePower! + 50) / 50
        waveView.amplitude = CGFloat(percentage)
        if audioPlayer?.isPlaying == false {
            UIDevice.current.isProximityMonitoringEnabled = false
            holdRecord.isEnabled = true
            play.setTitle("Play", for: .normal)
            play.setImage(UIImage(named: "Play.png"), for: .normal)
            timer?.invalidate()
        }
    }
    
    @objc func updateAudioRecordProgressView()
    {
        audioTime.text = format(duration: (audioRecorder?.currentTime)!)
        audioRecorder?.updateMeters()
        let averagePower = audioRecorder?.averagePower(forChannel: 0)
        let percentage = (averagePower! + 50) / 50
        waveView.amplitude = CGFloat(percentage)
        if audioRecorder?.isRecording == false {
            play.isEnabled = true
            createAudioPlayer()
            timer?.invalidate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = sourceName
        waveView.amplitude = 0
        
        createAudioRecorder()
        createAudioPlayer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
}
