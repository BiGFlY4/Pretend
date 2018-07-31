//
//  AppDelegate.swift
//  PretendCall
//
//  Created by Jifei sui on 2018/6/10.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var providerDelegate: ProviderDelegate?
    var callInfo = CallInfo()

    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let fileMgr = FileManager.default
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        if !fileMgr.fileExists(atPath: dirPaths[0].appendingPathComponent("Default.aif").path) {
            let fromURLDefault = Bundle.main.url(forResource: "Default", withExtension: "aif")
            let toURLDefault = dirPaths[0].appendingPathComponent("Default.aif")
            do {
                try fileMgr.copyItem(at: fromURLDefault!, to: toURLDefault)
            }
            catch let error {
                print(error.localizedDescription)
            }
            
            let fromURLCustom = Bundle.main.url(forResource: "Custom", withExtension: "aif")
            for destinationFile in ["Custom 1.aif","Custom 2.aif","Custom 3.aif"] {
                let toURL = dirPaths[0].appendingPathComponent(destinationFile)
                do {
                    try fileMgr.copyItem(at: fromURLCustom!, to: toURL)
                }
                catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        return true
    }

    func displayIncomingCall(callInfo: CallInfo, completion: ((Error?) -> Void)? = nil) {
        providerDelegate = ProviderDelegate(callInfo: callInfo)
        providerDelegate?.reportIncomingCall(completion: completion)
    }
    
    func endCall() {
        providerDelegate?.endCall()
    }
}

