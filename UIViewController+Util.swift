//
//  UIViewController+Util.swift
//  iFinder
//
//  Created by Tanner on 5/25/16.
//  Copyright © 2016 Tanner Bennett. All rights reserved.
//

import UIKit


extension UIViewController {
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}