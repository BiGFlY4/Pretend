//
//  MainNBController.swift
//  PretendCall
//
//  Created by 孟颖 李 on 2018/6/10.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit

class MainNBController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name("naviBarTap")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapMe(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .didReceiveData, object: nil)
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

extension Notification.Name {
    static let didReceiveData = Notification.Name("didReceiveData")
    static let didCompleteTask = Notification.Name("didCompleteTask")
    static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}
