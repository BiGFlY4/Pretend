//
//  CallerInfoViewController.swift
//  PretendCall
//
//  Created by Jifei sui on 2018/6/15.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit

class CallerInfoViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var callerList: UITableView!
    @IBOutlet weak var caller: UITextField!
    @IBOutlet weak var subtitle: UITextField!
    weak var callInfoDelegate: CallInfoDelegate?
    var callInfo: CallInfo?
    let callers = ["Dad", "Mum", "Darling", "Boss"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        caller.setLeftPaddingPoints(5)
        subtitle.setLeftPaddingPoints(5)
        caller.delegate = self
        subtitle.delegate = self
        caller.text = callInfo?.caller
        subtitle.text = callInfo?.callerInfo
        callerList.delegate = self
        callerList.dataSource = self
        callerList.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return callers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "callerlist", for: indexPath)
        cell.textLabel?.text = callers[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        caller.text = callers[indexPath.row]
        callerList.isHidden = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === caller {
            callerList.isHidden = false
        }
        else {
            callerList.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == caller {
            textField.resignFirstResponder()
            subtitle.becomeFirstResponder()
        } else if textField == subtitle {
            textField.resignFirstResponder()
            navigationController?.popViewController(animated: true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == caller, let callerText = caller.text{
            callInfoDelegate?.setCaller(with: callerText)
        }
        else if textField == subtitle, let subtitleText = subtitle.text {
            callInfoDelegate?.setSubtitle(with: subtitleText)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        caller.endEditing(false)
        subtitle.endEditing(false)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

