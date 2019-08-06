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
    
    @objc open func slideMenuDidSelectItem(_ vc: SlideMenuViewController?, _ menuItemId: String, completion: ((Bool) -> Void)? = nil)  {
        
        delegate?.slideMenuDidSelectItem(self, slideMenuController: vc, menuItemId: menuItemId, completion: completion)
        
    }
    
    @objc open func slideMenuDidOpen(_ vc: SlideMenuViewController) {
        self.slideMenuViewController = vc
        
        delegate?.slideMenuDidOpen(self, slideMenuController: vc)
    }
    
    @objc open func slideMenuDidClose() {
        self.slideMenuViewController = nil
        
        delegate?.slideMenuDidClose(self)
    }
    
    @objc open func slideMenuHeaderView(_ vc: SlideMenuViewController) -> UIView? {
        return delegate?.slideMenuHeaderView(self, slideMenuController: vc)
    }
    
    @objc open func slideMenuFooterView(_ vc: SlideMenuViewController) -> UIView? {
        return delegate?.slideMenuFooterView(self, slideMenuController: vc)
    }
    
    @objc open var slideMenuOptionCellClass: SlideMenuOptionTableViewCell.Type {
        return delegate?.slideMenuOptionCellClass ?? SlideMenuOptionTableViewCell.self
    }
    
    @objc open var slideMenuOptionTextColor : UIColor? {
        return delegate?.slideMenuOptionTextColor
    }
    @objc open var slideMenuOptionBackgroundColor : UIColor? {
        return delegate?.slideMenuOptionBackgroundColor
    }
    @objc open var slideMenuOptionTextFont : UIFont? {
        return delegate?.slideMenuOptionTextFont
    }
    
    @objc open var slideMenuFooterColor : UIColor? {
        return delegate?.slideMenuFooterColor
    }
    @objc open var slideMenuHeaderColor : UIColor? {
        return delegate?.slideMenuHeaderColor
    }
}
