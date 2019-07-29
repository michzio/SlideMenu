//
//  ViewEmbedder.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 29/07/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

enum TransitionDirection {
    case backward
    case forward
}

class ViewEmbedder {
    
    private var parentVC : UIViewController
    private var container : UIView
    private var isBackward : Bool = false
    private var timeInterval : TimeInterval = 0.25
    
    init(container: UIView, in parent: UIViewController) {
        self.container = container
        self.parentVC = parent
    }
    
    func setTransitionDirection(direction: TransitionDirection) -> Self {
        switch(direction) {
        case .backward:
            isBackward = true
        default:
            isBackward = false
        }
        
        return self
    }
    
    func setTimeInterval(_ timeInterval : TimeInterval) -> Self {
        self.timeInterval = timeInterval
        
        return self
    }
    
    func embed(child newVC: UIViewController,
               replacing oldVC: UIViewController?,
               completion: (() -> Void)? = nil )  {
        
        // prepare two view controllers for the change
        oldVC?.willMove(toParent: nil)
        parentVC.addChild(newVC)
        
        // add new view
        newVC.view.frame = self.newViewStartFrame
        container.addSubview(newVC.view)
        
        UIView.animate(withDuration: timeInterval, animations: {
            
            // animate old/new view frames
            newVC.view.frame = self.newViewEndFrame
            oldVC?.view.frame = self.oldViewEndFrame
            
        }, completion: { finished in
            
            // remove old view controller
            oldVC?.view.removeFromSuperview()
            oldVC?.removeFromParent()
            
            // end new view controller addition
            newVC.didMove(toParent: self.parentVC)
            
            completion?()
        })
        
    }
    
    private var newViewStartFrame : CGRect {
        return CGRect(x: (isBackward ? -1 : 1) * container.frame.width, y: 0,
                      width: container.frame.width,
                      height: container.frame.height)
    }
    
    private var newViewEndFrame : CGRect {
        return CGRect(x: 0, y: 0,
                      width: container.frame.width,
                      height: container.frame.height)
    }
    
    private var oldViewEndFrame : CGRect {
        return CGRect(x: (isBackward ? 1 : -1) * container.frame.width, y: 0,
                      width: container.frame.width,
                      height: container.frame.height)
    }
}
