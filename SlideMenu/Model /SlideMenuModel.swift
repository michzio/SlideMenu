//
//  SlideMenuModel.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 29/07/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import Foundation

public struct SlideMenuItem {
    var title : String
    var id: String
    var icon : UIImage
    var badge : Int?
    
    init(title: String, id: String, icon: UIImage, badge: Int? = nil) {
        self.title = title
        self.id = id
        self.icon = icon
        self.badge = badge
    }
}

extension SlideMenuItem {
    enum Labels : String {
        case SignOut
    }
}

class SlideMenuModel {
    
    static var chevronImage : UIImage {
        return UIImage(named:"chevron-right", in: Bundle(for: self), compatibleWith:nil)!
    }
    
    static var example : [SlideMenuItem] = [
        SlideMenuItem(title: "Example", id: "example", icon: chevronImage)
    ]
}
