//
//  DelayViewController.swift
//  PretendCall
//
//  Created by Jifei sui on 2018/6/28.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit

class DelayViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var delayPicker: UIPickerView!
    weak var callInfoDelegate: CallInfoDelegate?
    var callInfo: CallInfo?
    
    @IBAction func doneForDelay(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 60
        case 1:
            return 1
        case 2:
            return 60
        case 3:
            return 1
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if [0, 2].contains(component) {
            return 80
        }
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if [0, 2].contains(component) {
            let label = UILabel()
            label.text = String(row)
            label.textAlignment = .right
            label.font = UIFont(name: "Helvetica", size: 25.0)
            return label
        }
        else if component == 1 {
            let label = UILabel()
            label.text = "min"
            label.textAlignment = .left
            label.font = UIFont(name: "Helvetica", size: 20.0)
            return label
        }
        else if component == 3 {
            let label = UILabel()
            label.text = "sec"
            label.textAlignment = .left
            label.font = UIFont(name: "Helvetica", size: 20.0)
            return label
        }
        return UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delayPicker.delegate = self
        delayPicker.dataSource = self
        delayPicker.selectRow((callInfo?.delayMin)!, inComponent:0, animated:true)
        delayPicker.selectRow((callInfo?.delaySec)!, inComponent:2, animated:true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        callInfoDelegate?.setDelayMin(min: delayPicker.selectedRow(inComponent: 0))
        callInfoDelegate?.setDelaySec(sec: delayPicker.selectedRow(inComponent: 2))
    }
}
