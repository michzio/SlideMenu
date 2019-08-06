//
//  SlideMenuBaseViewController+SlideMenuDelegate.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 06/08/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

// MARK: - Slide Menu Delegate
extension SlideMenuBaseViewController : SlideMenuDelegate {
    
    public func slideMenuDidSelectItem(_ vc: SlideMenuViewController?, _ menuItemId: String) {
        slideMenuDidSelectItem(vc, menuItemId, completion: nil)
    }
    
    open func slideMenuDidSelectItem(_ vc: SlideMenuViewController?, _ menuItemId: String, completion: ((Bool) -> Void)? = nil)  {
        
        delegate?.slideMenuDidSelectItem(self, slideMenuController: vc, menuItemId: menuItemId, completion: completion)
        
    }
    
    open func slideMenuDidOpen(_ vc: SlideMenuViewController) {
        self.slideMenuViewController = vc
        
        delegate?.slideMenuDidOpen(self, slideMenuController: vc)
    }
    
    open func slideMenuDidClose() {
        self.slideMenuViewController = nil
        
        delegate?.slideMenuDidClose(self)
    }
    
    open func slideMenuHeaderView(_ vc: SlideMenuViewController) -> UIView? {
        return delegate?.slideMenuHeaderView(self, slideMenuController: vc)
    }
    
    open func slideMenuFooterView(_ vc: SlideMenuViewController) -> UIView? {
        return delegate?.slideMenuFooterView(self, slideMenuController: vc)
    }
    
    open var slideMenuOptionCellClass: SlideMenuOptionTableViewCell.Type {
        return delegate?.slideMenuOptionCellClass ?? SlideMenuOptionTableViewCell.self
    }
    
    open var slideMenuOptionTextColor : UIColor? {
        return delegate?.slideMenuOptionTextColor
    }
    open var slideMenuOptionBackgroundColor : UIColor? {
        return delegate?.slideMenuOptionBackgroundColor
    }
    open var slideMenuOptionTextFont : UIFont? {
        return delegate?.slideMenuOptionTextFont
    }
    
    open var slideMenuFooterColor : UIColor? {
        return delegate?.slideMenuFooterColor
    }
    open var slideMenuHeaderColor : UIColor? {
        return delegate?.slideMenuHeaderColor
    }
}
