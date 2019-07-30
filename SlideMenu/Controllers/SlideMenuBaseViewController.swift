//
//  SlideMenuBaseViewController.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 29/07/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

class SlideMenuBaseViewController: UIViewController, SlideMenuDelegate {
    
    var slideMenuViewController: SlideMenuViewController? = nil

    // MARK: - SLIDE MENU BAR BUTTON
    open var barsIcon : UIImage {
        //fatalError("Implement bars icon for slide menu")
        return menuImage
    }
    
    open var barsHighlightedIcon : UIImage {
        //fatalError("Implement highlighted bars icon for slide menu")
        return menuImage.colored(.darkGray)
    }
    
    /* enables to add Hamburger Button to Navigation Bar */
    open var slideMenuBarButton : UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setImage(barsIcon, for: .normal)
        button.setImage(barsHighlightedIcon, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        button.backgroundColor = .white
        //button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(self.didTapSlideMenuBarButton(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    @objc func didTapSlideMenuBarButton(_ sender: UIBarButtonItem) {
        
        sender.isEnabled = false
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "SlideMenu", bundle: nil)
        let slideMenuVC = storyboard.instantiateViewController(withIdentifier: SlideMenuViewController.identifier) as! SlideMenuViewController
        slideMenuVC.delegate = self
        slideMenuVC.openSlideMenu(over: self) { sender.isEnabled = true }
    }

    // MARK: - BACK BAR BUTTON
    open var backIcon : UIImage {
        //fatalError("Implement back icon for navigation bar")
        return backImage
    }
    
    open var backHighlightedIcon : UIImage {
        //fatalError("Implement highlighted back icon for navigation bar")
        return backImage.colored(.darkGray)
    }
    
 
    /* enables to add Back Button to Navigation Bar */
    open var backBarButton : UIBarButtonItem {
        
        let button = UIButton(type: .system)
        button.setImage(backIcon, for: .normal)
        button.setImage(backHighlightedIcon, for: .highlighted)
        button.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        button.backgroundColor = .white
        //button.layer.cornerRadius = 2
        button.addTarget(self, action: #selector(self.didTapBackButton(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    @objc func didTapBackButton(_ sender : UIButton) {
        if let nc = self.navigationController  {
            _ = nc.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
        // turn on Tab Bar items highlight
        // if come back to its view controllers hierarchy
        if let nc = self.navigationController {
            if self.tabBarController?.viewControllers?.contains(nc) == true {
                if nc.viewControllers.contains(where: { $0 is ContainerViewController }) == false {
                    (self.tabBarController as? TabBarViewController)?.highlightSelectedItem(true)
                }
            }
        }
    }
    
    // MARK: - Slide Menu Delegate
    func slideMenuDidSelectItem(_ vc: SlideMenuViewController?, _ menuItemId: String) {
        slideMenuDidSelectItem(vc, menuItemId, completion: nil)
    }
    
    open func slideMenuDidSelectItem(_ vc: SlideMenuViewController?, _ menuItemId: String, completion: ((Bool) -> Void)? = nil)  {
        
    }
    
    open func slideMenuDidOpen(_ vc: SlideMenuViewController) {
        self.slideMenuViewController = vc
    }
    
    open func slideMenuDidClose() {
        self.slideMenuViewController = nil
    }
}

// MARK: - PUBLIC METHODS
extension SlideMenuBaseViewController {
    
    public func addSlideMenuBarButton(_ viewController: UIViewController? = nil) {
        
        if let vc = viewController {
            vc.navigationItem.rightBarButtonItem = slideMenuBarButton
        } else {
            self.navigationItem.rightBarButtonItem = slideMenuBarButton
        }
    }
    
    public func addCustomBackBarButton(_ viewController: UIViewController? = nil) {
        
        if let vc = viewController {
            vc.navigationItem.leftBarButtonItem = backBarButton
        } else {
            self.navigationItem.leftBarButtonItem = backBarButton
        }
    }
    
}

// MARK: - PUBLIC METHODS - NAVIGATION
extension SlideMenuBaseViewController {

    public func selectTabBar(index: Int, userInfo: [String: AnyObject]? = nil, completion: ((Bool) -> Void)? = nil) {
        
        guard let tbc = self.tabBarController else { completion?(false); return }
        
        if tbc.selectedIndex == index {
            // when selected index and tab bar index are equal,
            // back to root view controller of current tab
            _ = self.navigationController?.popToRootViewController(animated: true) {
                completion?(true)
            }
        } else {
            tbc.selectedIndex = index
            completion?(true)
        }
        
        (tabBarController as? TabBarViewController)?.highlightSelectedItem(true)
    }
    
    public func selectContainerView(viewController identifier: String, storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil), completion: ((Bool) -> Void)? = nil) {
        
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        selectContainerView(viewController: vc)
    }
    
    public func selectContainerView(viewController vc: UIViewController, completion: ((Bool) -> Void)? = nil) {
    
        guard !popToViewControllerIfExists(vc) else { completion?(false); return }
        
        // searching ContainerViewController in current hirerarchy
        var next : UIViewController? = self
        var cvc = next as? ContainerViewController
        while cvc == nil && next != nil {
            next = next?.parent
            cvc = parent as? ContainerViewController
        }
        
        cvc = cvc ?? popToLastContainerViewControllerIfExists()
        
        if let cvc = cvc {
            cvc.setContentView(viewController: vc, transition: .backward, completion: completion)
        } else {
            
            let storyboard = UIStoryboard(name: "SlideMenu", bundle: nil)
            let cvc = storyboard.instantiateViewController(withIdentifier: ContainerViewController.identifier) as! ContainerViewController
            
            self.show(cvc, sender: cvc)
            cvc.loadViewIfNeeded()
            cvc.setContentView(viewController: vc, timeInterval: 0, completion: completion)
        }
    
        (tabBarController as? TabBarViewController)?.highlightSelectedItem(false)
    }
    
    private func popToViewControllerIfExists(_ vc: UIViewController) -> Bool {
        if let nc = self.navigationController {
            if let firstContainerViewController = nc.viewControllers.first(where: {
                if let cvc = $0 as? ContainerViewController {
                    return cvc.contentViewController?.classForCoder == vc.classForCoder
                }
                return false
            }) {
                self.view.alpha = 0
                nc.popToViewController(firstContainerViewController, animated: true) {
                    self.view.alpha = 1
                }
                return true
            }
        }
        
        return false
    }
    
    private func popToLastContainerViewControllerIfExists() -> ContainerViewController? {
        
        if let nc = self.navigationController {
            if let cvc = nc.viewControllers.last(where: {
                $0 is ContainerViewController
            }) as? ContainerViewController {
                self.view.alpha = 0
                nc.popToViewController(cvc, animated: true) {
                    self.view.alpha = 1
                }
                return cvc
            }
        }
        
        return nil
    }
    
    private func popToFirstContainerViewControllerIfExists() -> ContainerViewController? {
        
        if let nc = self.navigationController {
            if let cvc = nc.viewControllers.first(where: {
                $0 is ContainerViewController
            }) as? ContainerViewController {
                nc.popToViewController(cvc, animated: false)
                return cvc
            }
        }
        
        return nil
    }
    
    private func selectWindow(rootViewController identifier: String, storyboard name: String = "iPhone",  completion: ((Bool) -> Void)? = nil ) {
        
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        
        selectWindow(rootViewController: vc, completion: completion)
    }
    
    private func selectWindow(rootViewController: UIViewController, completion: ((Bool) -> Void)? = nil) {
        
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.set(rootViewController: rootViewController, completion: completion)
    }
}

extension SlideMenuBaseViewController {
    
    private var menuImage : UIImage {
        return UIImage(named: "menu",
                       in: Bundle(for: SlideMenuBaseViewController.self),
                       compatibleWith: nil)!
    }
    
    private var backImage : UIImage {
        return UIImage(named: "chevron-left", in: Bundle(for: SlideMenuBaseViewController.self), compatibleWith: nil)!
    }
}
