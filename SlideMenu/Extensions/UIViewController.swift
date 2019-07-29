//
//  UIViewController.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 29/07/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

// MARK: - Storyboard Identifiers
extension UIViewController {
    
    @objc class var identifier: String {
        return String(describing: self)
    }
}
