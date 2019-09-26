//
//  UIWindowExtensions.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 29/07/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

extension UIWindow {
    
    func set(rootViewController newViewController: UIViewController, withTransition transition: CATransition? = nil, completion: ((Bool) -> Void)? = nil ) {
        
        let previousViewController = self.rootViewController
        
        if let transition = transition {
            // Add the transition
            layer.add(transition, forKey: kCATransition)
        }
        
        self.rootViewController = newViewController
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        if #available(iOS 13, *) {
            /// Do nothing here
        } else {
            /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
            if let transitionViewClass = NSClassFromString("UITransitionView") {
                for subview in self.subviews where subview.isKind(of: transitionViewClass) {
                    subview.removeFromSuperview()
                }
            }
        }
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
        
        completion?(true)
    }
}
