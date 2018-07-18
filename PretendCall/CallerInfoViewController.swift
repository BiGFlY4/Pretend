//
//  CallerInfoViewController.swift
//  PretendCall
//
//  Created by 孟颖 李 on 2018/6/15.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit

class CallerInfoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var caller: UITextField!
    @IBOutlet weak var subtitle: UITextField!
    weak var callInfoDelegate: CallInfoDelegate?
    var callInfo: CallInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        caller.setLeftPaddingPoints(5)
        subtitle.setLeftPaddingPoints(5)
        caller.delegate = self
        subtitle.delegate = self
        caller.text = callInfo?.caller
        subtitle.text = callInfo?.callerInfo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

