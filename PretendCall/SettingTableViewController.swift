//
//  SettingTVC.swift
//  PretendCall
//
//  Created by 孟颖 李 on 2018/6/14.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit

protocol CallInfoDelegate: class {
    func setCaller(with caller: String)
    func setSubtitle(with subtitle: String)
    func setAudio(with audio: String)
    func setDelayMin(min: Int)
    func setDelaySec(sec: Int)
}

class SettingTVC: UITableViewController, CallInfoDelegate {

    @IBOutlet weak var callerInfo: UITableViewCell!
    @IBOutlet weak var audioResource: UITableViewCell!
    @IBOutlet weak var delayTime: UITableViewCell!
    @IBOutlet weak var recordRecentButton: UISwitch!
    
    weak var callStructDelegate: CallStructDelegate?
    var callInfo: CallInfo?
    
    func setCaller(with caller: String) {
        callInfo?.caller = caller
    }
    
    func setSubtitle(with subtitle: String) {
        callInfo?.callerInfo = subtitle
    }
    
    func setAudio(with audio: String) {
        callInfo?.audioResource = audio + ".aif"
    }
    
    func setDelayMin(min: Int) {
        callInfo?.delayMin = min
    }
    
    func setDelaySec(sec: Int) {
        callInfo?.delaySec = sec
    }

    func updateDetail() {
        callerInfo.detailTextLabel?.text = (callInfo?.caller)! + ", " + (callInfo?.callerInfo)!
        audioResource.detailTextLabel?.text = callInfo?.audioResource.components(separatedBy:".")[0]
        delayTime.detailTextLabel?.text = String((callInfo?.delayMin)!) + "m " + String((callInfo?.delaySec)!) + "s"
        recordRecentButton.isOn = (callInfo?.recordRecent)!
    }
    
    @objc func recordRecentButtonChanged(_ sender: UISwitch) {
        callInfo?.recordRecent = recordRecentButton.isOn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateDetail()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "callerinfo" {
            let secondViewController = segue.destination as! CallerInfoViewController
            secondViewController.callInfoDelegate = self
            secondViewController.callInfo = callInfo
        }
        else if segue.identifier == "audioinfo" {
            let secondViewController = segue.destination as! AudioTableViewController
            secondViewController.callInfoDelegate = self
        }
        else if segue.identifier == "delayinfo" {
            let secondViewController = segue.destination as! DelayViewController
            secondViewController.callInfoDelegate = self
            secondViewController.callInfo = callInfo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            recordRecentButton.addTarget(self, action: #selector(recordRecentButtonChanged), for: UIControlEvents.valueChanged)
        }
        else {
            recordRecentButton.isEnabled = false
        }

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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        else if section == 1 {
            return 1
        }
        else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [1, 0] {
            navigationController?.popViewController(animated: true)
            callStructDelegate?.startCall()
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            callStructDelegate?.setCallStruct(with: callInfo!)
        }
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
