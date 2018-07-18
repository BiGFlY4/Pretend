//
//  CallDelegate.swift
//  PretendCall
//
//  Created by 孟颖 李 on 2018/6/12.
//  Copyright © 2018年 Jifei sui. All rights reserved.
//

import Foundation
import CallKit
import UIKit

class callDelegate: NSObject,  {
    func providerDidReset(_ provider: CXProvider) {
    }
    
    override init() {

    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill()
    }
}
