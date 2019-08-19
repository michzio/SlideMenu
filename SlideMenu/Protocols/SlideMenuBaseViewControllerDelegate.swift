//
//  SlideMenuBaseViewControllerDelegate.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 06/08/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

public protocol SlideMenuBaseViewControllerDelegate : class {
    
    var barsIcon : UIImage { get }
    var barsIconHighlighted : UIImage { get }
    
    var backIcon : UIImage { get }
    var backIconHighlighted : UIImage { get }
    
    func didTapSlideMenuBarButton(_ baseController: SlideMenuBaseViewController, sender: UIBarButtonItem)
    
    func slideMenuDidSelectItem(_ baseController: SlideMenuBaseViewController, slideMenuController: SlideMenuViewController?, menuItemId: String, completion: ((Bool) -> Void)?)
    func slideMenuDidOpen(_ baseController: SlideMenuBaseViewController, slideMenuController: SlideMenuViewController?)
    func slideMenuDidClose(_ baseController: SlideMenuBaseViewController)
    func slideMenuHeaderView(_ baseController: SlideMenuBaseViewController, slideMenuController: SlideMenuViewController?) -> UIView?
    func slideMenuFooterView(_ baseController: SlideMenuBaseViewController, slideMenuController: SlideMenuViewController?) -> UIView?
    
    var slideMenuOptionCellClass : SlideMenuOptionTableViewCell.Type { get }
    
    var slideMenuOptionTextColor : UIColor? { get }
    var slideMenuOptionBackgroundColor : UIColor? { get }
    var slideMenuOptionTextFont : UIFont? { get }
    
    var slideMenuFooterColor : UIColor? { get }
    var slideMenuHeaderColor : UIColor? { get }
    
    var isContainerToSafeArea : Bool { get }
    
    var containerView : UIView? { get }
    var bottomSafeAreaView : UIView? { get }
}

public extension SlideMenuBaseViewControllerDelegate {
    
    var barsIcon : UIImage {
        return UIImage(named: "menu",
                       in: Bundle(for: SlideMenuBaseViewController.self),
                       compatibleWith: nil)!
    }
    
    var barsIconHighlighted : UIImage {
        let image = UIImage(named: "menu",
                            in: Bundle(for: SlideMenuBaseViewController.self),
                            compatibleWith: nil)!
        return image.colored(.darkGray)
    }
    
    var backIcon : UIImage {
        return UIImage(named: "chevron-left", in: Bundle(for: SlideMenuBaseViewController.self), compatibleWith: nil)!
    }
    var backIconHighlighted : UIImage {
        let image = UIImage(named: "chevron-left", in: Bundle(for: SlideMenuBaseViewController.self), compatibleWith: nil)!
        return image.colored(.darkGray)
    }
    
    func didTapSlideMenuBarButton(_ baseController: SlideMenuBaseViewController, sender: UIBarButtonItem) { }
    
    func slideMenuDidSelectItem(_ baseController: SlideMenuBaseViewController, slideMenuController: SlideMenuViewController, menuItemId: String, completion: ((Bool) -> Void)? = nil) { }
    func slideMenuDidOpen(_ baseController: SlideMenuBaseViewController, slideMenuController: SlideMenuViewController?) { }
    func slideMenuDidClose(_ baseController: SlideMenuBaseViewController) { }
    
    func slideMenuHeaderView(_ baseController: SlideMenuBaseViewController, slideMenuController: SlideMenuViewController?) -> UIView? { return nil }
    func slideMenuFooterView(_ baseController: SlideMenuBaseViewController, slideMenuController: SlideMenuViewController?) -> UIView? { return nil }
    
    var slideMenuOptionCellClass : SlideMenuOptionTableViewCell.Type {
        return SlideMenuOptionTableViewCell.self
    }
    
    var slideMenuOptionTextColor : UIColor? { return nil  }
    var slideMenuOptionBackgroundColor : UIColor? { return nil  }
    var slideMenuOptionTextFont : UIFont? { return nil  }
    
    var slideMenuFooterColor : UIColor? { return nil }
    var slideMenuHeaderColor : UIColor? { return nil }
    
   
    var isContainerToSafeArea : Bool { return true }
    
    var containerView : UIView? { return nil  }
    var bottomSafeAreaView : UIView? { return nil }
}
