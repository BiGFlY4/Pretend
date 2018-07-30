//
//  AppDelegate.swift
//  PretendCall
//
//  Created by 孟颖 李 on 2018/6/10.
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
        if !fileMgr.fileExists(atPath: dirPaths[0].appendingPathComponent("Default.mp3").path) {
            let fromURLDefault = Bundle.main.url(forResource: "Default", withExtension: "mp3")
            let fromURLCustom = Bundle.main.url(forResource: "Custom", withExtension: "mp3")
            let toURLDefault = dirPaths[0].appendingPathComponent("Default.mp3")
            do {
                try fileMgr.copyItem(at: fromURLDefault!, to: toURLDefault)
            }
            catch let error {
                print(error.localizedDescription)
            }
            for destinationFile in ["Custom 1.mp3","Custom 2.mp3","Custom 3.mp3"] {
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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func displayIncomingCall(callInfo: CallInfo, completion: ((Error?) -> Void)? = nil) {
        providerDelegate = ProviderDelegate(callInfo: callInfo)
        providerDelegate?.reportIncomingCall(completion: completion)
    }
    
    func endCall() {
        providerDelegate?.endCall()
    }
}

