//
//  CallInfo.swift
//  PretendCall
//
//  Created by Jifei sui on 2018/6/12.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import Foundation

struct CallInfo {
    var caller: String
    var callerInfo: String
    var audioResource: String
    var delayMin: Int
    var delaySec: Int
    var recordRecent: Bool
    
    init() {
        caller = CallInfo.randomNumGenerator()
        callerInfo = "VoIP"
        audioResource = "Default.mp3"
        delayMin = 0
        delaySec = 5
        recordRecent = false
    }
    
    static func randomNumGenerator() -> String {
        var numPrefix:[Int] = [135, 136, 137, 138, 139, 150, 151, 152, 158, 159, 187, 188,
        130, 131, 132, 155, 156, 185, 186,
        133, 153, 180, 189]
        
        let randomIndex = Int(arc4random_uniform(UInt32(numPrefix.count)))
        var rndNum = numPrefix[randomIndex]
        for _ in 0...7 {
            rndNum = 10 * rndNum + Int(arc4random_uniform(10))
        }
        return String(rndNum)
    }
}
