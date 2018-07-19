//
//  MainNaviController.swift
//  PretendCall
//
//  Created by 孟颖 李 on 2018/7/18.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit

class MainNaviController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapMe(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .didTapNaviBar, object: nil)
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
    static let didTapNaviBar = Notification.Name("didTapNaviBar")
}
