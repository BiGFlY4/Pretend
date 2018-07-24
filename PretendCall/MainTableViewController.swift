//
//  MainTableViewController.swift
//  PretendCall
//
//  Created by 孟颖 李 on 2018/7/18.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit
import CallKit

protocol CallStructDelegate: class {
    func setCallStruct(with data: CallInfo)
    func startCall()
}

class MainTableViewController: UITableViewController,CXCallObserverDelegate,CallStructDelegate {

    @IBOutlet weak var naviBarItem: UINavigationItem!
    @IBOutlet weak var callNowButton: UIBarButtonItem!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var stopCallButton: UIBarButtonItem!
    @IBOutlet weak var segView: UIView!
    weak var timer: Timer?
    var providerDelegate: ProviderDelegate?
    var callObserver: CXCallObserver?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    var backgroundTask: DispatchWorkItem?
    var delay: Double?
    var callInfo = CallInfo()
    var naviBarDelayTitle = false
    
    @IBAction func callNow(_ sender: UIBarButtonItem) {
        let callInfoNow = CallInfo()
        providerDelegate = ProviderDelegate(callInfo: callInfoNow)
        providerDelegate?.reportIncomingCall() { error in }
    }
    
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
        callNowButton.image = UIImage(named: "Call.png")
        cancelButton.isEnabled = false
        cancelButton.title = nil
        cancelButton.image = nil
        naviBarItem.title = "News Feed"
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
        if naviBarItem.title != "News Feed" {
            naviBarDelayTitle = !naviBarDelayTitle
        }
    }
    
    func startCall() {
        settingButton.isEnabled = false
        callNowButton.isEnabled = false
        callNowButton.title = nil
        callNowButton.image = nil
        stopCallButton.title = nil
        stopCallButton.image = nil
        cancelButton.isEnabled = true
        cancelButton.title = "Cancel"
        cancelButton.image = UIImage(named: "Stop.png")
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
            stopCallButton.image = nil
            settingButton.isEnabled = true
            callNowButton.isEnabled = true
            callNowButton.title = "CallNow"
            callNowButton.image = UIImage(named: "Call.png")
            timer?.invalidate()
            naviBarItem.title = "News Feed"
        }
        else if call.isOutgoing == false && call.hasConnected == false && call.hasEnded == false {
            self.settingButton.isEnabled = false
            self.callNowButton.isEnabled = false
            self.callNowButton.title = nil
            self.callNowButton.image = nil
            self.cancelButton.isEnabled = false
            self.cancelButton.title = nil
            self.cancelButton.image = nil
            self.stopCallButton.isEnabled = true
            self.stopCallButton.title = "Stop"
            self.stopCallButton.image = UIImage(named: "EndCall.png")
            timer?.invalidate()
            naviBarItem.title = "News Feed"
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
        segView.addBottomBorderWithColor(color: .groupTableViewBackground, width: 1)
        cancelButton.title = nil
        cancelButton.image = nil
        stopCallButton.title = nil
        stopCallButton.image = nil
        callObserver = CXCallObserver()
        callObserver?.setDelegate(self, queue: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(triggerNaviTitle(_:)), name: .didTapNaviBar, object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
}
