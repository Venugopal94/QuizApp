//
//  UIViewController+Extension.swift
//  SingularityDemoApp
//
//  Created by venu Gopal on 03/05/20.
//  Copyright © 2020 venu Gopal. All rights reserved.
//

import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
