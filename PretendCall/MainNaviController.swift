//
//  MainNaviController.swift
//  PretendCall
//
//  Created by Jifei sui on 2018/7/18.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import UIKit

class MainNaviController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapMe(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .didTapNaviBar, object: nil)
    }
}

extension Notification.Name {
    static let didTapNaviBar = Notification.Name("didTapNaviBar")
}
