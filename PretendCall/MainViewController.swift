//
//  MainViewController.swift
//  PretendCall
//
//  Created by 孟颖 李 on 2018/6/10.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit
import CallKit

protocol CallStructDelegate: class {
    func setCallStruct(with data: CallInfo)
    func startCall()
}

class MainViewController: UIViewController, CXCallObserverDelegate,CallStructDelegate{
    
    @IBOutlet weak var naviBarItem: UINavigationItem!
    @IBOutlet weak var callNowButton: UIBarButtonItem!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var stopCallButton: UIBarButtonItem!
    weak var timer: Timer?
    var providerDelegate: ProviderDelegate?
    var callObserver: CXCallObserver?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    var backgroundTask: DispatchWorkItem?
    var delay: Double?
    var callInfo = CallInfo()
    var naviBarDelayTitle = false
    
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        if backgroundTask != nil {
            backgroundTask?.cancel()
        }
        if backgroundTaskIdentifier != nil {
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier!)
        }
        settingButton.isEnabled = true
        callNowButton.isEnabled = true
        callNowButton.title = "CallNow"
        cancelButton.isEnabled = false
        cancelButton.title = nil
        naviBarItem.title = "News"
        timer?.invalidate()
    }
    
    @IBAction func stopCallButtonAction(_ sender: UIBarButtonItem) {
        AppDelegate.shared.endCall()
        providerDelegate?.endCall()
    }
    
    func setCallStruct(with data: CallInfo) {
        self.callInfo = data
    }
    
    @objc func triggerNaviTitle(_ notification:Notification) {
        if naviBarItem.title != "News" {
            naviBarDelayTitle = !naviBarDelayTitle
        }
    }
    
    func startCall() {
        settingButton.isEnabled = false
        callNowButton.isEnabled = false
        callNowButton.title = nil
        stopCallButton.title = nil
        cancelButton.isEnabled = true
        cancelButton.title = "Cancel"
        naviBarItem.title = "TapMe"
        naviBarDelayTitle = false
        delay = Double(callInfo.delayMin * 60 + callInfo.delaySec)
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        backgroundTask = DispatchWorkItem {
            AppDelegate.shared.displayIncomingCall(callInfo: self.callInfo) { _ in
                UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
            }
        }
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + TimeInterval(delay!), execute: backgroundTask!)
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateDelayProgressView), userInfo: nil, repeats: true)
    }
    
    @objc func updateDelayProgressView() {
        if naviBarDelayTitle {
            naviBarItem.title = format(delay: delay!)
        }
        else {
            naviBarItem.title = "TapMe"
        }
        delay! -= 0.2
    }
    
    func format(delay: Double) -> String {
        if delay < 0.0 {
            return "00:00"
        }
        let interval = Int(delay.rounded())
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded == true {
            stopCallButton.isEnabled = false
            stopCallButton.title = nil
            settingButton.isEnabled = true
            callNowButton.isEnabled = true
            callNowButton.title = "CallNow"
            timer?.invalidate()
            naviBarItem.title = "News"
        }
        else if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            self.settingButton.isEnabled = false
            self.callNowButton.isEnabled = false
            self.callNowButton.title = nil
            self.cancelButton.isEnabled = false
            self.cancelButton.title = nil
            self.stopCallButton.isEnabled = true
            self.stopCallButton.title = "Stop"
            timer?.invalidate()
            naviBarItem.title = "News"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "callSetting" {
            let secondViewController = segue.destination as! SettingTVC
            secondViewController.callStructDelegate = self
            secondViewController.callInfo = callInfo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.title = nil
        stopCallButton.title = nil
        callObserver = CXCallObserver()
        callObserver?.setDelegate(self, queue: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(triggerNaviTitle(_:)), name: .didReceiveData, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callNow(_ sender: UIBarButtonItem) {
        let callInfoNow = CallInfo()
        providerDelegate = ProviderDelegate(callInfo: callInfoNow)
        providerDelegate?.reportIncomingCall() { error in }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
