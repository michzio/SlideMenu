//
//  UITableViewCellExtensions.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 29/07/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    @objc class var identifier : String {
        return String(describing: self)
    }
}
