//
//  ProviderDelegate.swift
//  PretendCall
//
//  Created by 孟颖 李 on 2018/6/17.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import Foundation
import UIKit
import CallKit
import AVFoundation

class ProviderDelegate: NSObject, CXProviderDelegate {
    
    var uuid: UUID?
    var audioIns: AudioSession?
    var provider: CXProvider
    let callInfo: CallInfo

    init(callInfo: CallInfo) {
        self.callInfo = callInfo
        audioIns = AudioSession(with: self.callInfo.audioResource)
        let config = CXProviderConfiguration(localizedName: callInfo.callerInfo)
        if #available(iOS 11.0, *) {
            config.includesCallsInRecents = callInfo.recordRecent
        }
        config.supportsVideo = true;
        config.iconTemplateImageData = UIImagePNGRepresentation(UIImage(named: "Ellipsis.png")!)
        provider = CXProvider(configuration: config)
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    func providerDidReset(_ provider: CXProvider) {
        stopAudio()
    }
    
    func reportIncomingCall(completion: ((NSError?) -> Void)?) {
        let update = CXCallUpdate()
        uuid = UUID()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: callInfo.caller)
        update.hasVideo = false
        provider.reportNewIncomingCall(with: uuid!, update: update, completion: { error in
            completion?(error as NSError?)
        })
    }
    
    func endCall() {
        let controller = CXCallController()
        let endCallAction = CXEndCallAction(call: uuid!)
        let transaction = CXTransaction(action: endCallAction)
        controller.request(transaction) { error in
            if let error = error {
                print("EndCallAction transaction request failed: \(error.localizedDescription).")
                self.provider.reportCall(with: self.uuid!, endedAt: Date(), reason: .remoteEnded)
                return
            }
        }
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        startAudio()
        audioIns?.audioPlay()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        startAudio()
        audioIns?.configureAudioSession()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
        stopAudio()
    }
}




