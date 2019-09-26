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
    
    public init(title: String, id: String, icon: UIImage, badge: Int? = nil) {
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

open class SlideMenuModel : SlideMenuDataSource {
  
    public static var chevronImage : UIImage {
        return UIImage(named:"chevron-right", in: Bundle(for: self), compatibleWith:nil)!
    }
    
    public init() { }
    
    open var menuItems: [SlideMenuItem] {
        return [
            SlideMenuItem(title: "Example", id: "example", icon: SlideMenuModel.chevronImage)
        ]
    }
    
    open var signOutButtonTitle: NSAttributedString? {
        return nil
    }
    
    open var loginButtonTitle: NSAttributedString? {
        return nil
    }
    
    open var isLoggedIn: Bool {
        return false
    }
    
}
