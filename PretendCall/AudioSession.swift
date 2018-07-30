//
//  AudioSession.swift
//  PretendCall
//
//  Created by 孟颖 李 on 2018/6/13.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import Foundation
import AVFoundation

class AudioSession {
    var player: AVAudioPlayer?
    var resource: String
    
    init?(with resource: String = "Default.mp3") {
        if resource == "None.mp3" {
            return nil
        }
        else {
            self.resource = resource
        }
    }
    
    func configureAudioSession() {
        print("Configuring audio session")
        
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        let soundFileURL = dirPaths[0].appendingPathComponent(resource)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setMode(AVAudioSessionModeVoiceChat)
            player = try AVAudioPlayer(contentsOf: soundFileURL)
        } catch let error {
            print("AudioSession error: " + error.localizedDescription)
        }
    }
    
    func audioPlay(isMeteringEnabled:Bool = false) {
        guard let player = player else { return }
        player.play()
    }
}

func startAudio() {
    print("Starting audio")
}

func stopAudio() {
    print("Stopping audio")
}
