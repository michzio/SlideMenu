//
//  TabBarViewController.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 29/07/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    open class var tabBarSelectedColor : UIColor {
        return UIColor.red
    }
    
    open class var selectedTintColor: UIColor {
        return UIColor.white
    }
    
    open class var tabBarColor : UIColor {
        return UIColor.white
    }
    
    open class var tintColor: UIColor {
        return UIColor.black
    }
    
    private var selectionIndicatorColor : UIColor = tabBarSelectedColor
    private var selectionTintColor : UIColor = selectedTintColor
    
    private var isInitialized : Bool = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // init tab bar on first appear
        if !isInitialized { highlightSelectedItem(true); isInitialized = true }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // only look & feel
        configTabBar()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        popSelectedItemToRoot(item)
        
        // turn on highlighting always
        // if direct tab bar item selection
        highlightSelectedItem(true)
        self.view.setNeedsLayout()
    }
}

extension TabBarViewController {
    
    private var selectionIndicatorImage : UIImage  {
        return UIImage.withColor(selectionIndicatorColor, size: CGSize(width: (self.tabBar.frame.width - (2 * self.tabBar.subviews[1].frame.origin.x)) / CGFloat((self.tabBar.items?.count)!), height: self.tabBar.frame.height))
    }
    
    func highlightSelectedItem(_ flag: Bool) {
        if flag {
            selectionIndicatorColor = TabBarViewController.tabBarSelectedColor
            selectionTintColor = TabBarViewController.selectedTintColor
        } else {
            selectionIndicatorColor = TabBarViewController.tabBarColor
            selectionTintColor = TabBarViewController.tintColor
        }
        
        tabBar.selectionIndicatorImage = selectionIndicatorImage
        tabBar.tintColor = selectionTintColor
        view.setNeedsLayout()
    }
}

// MARK: - PRIVATE METHODS
extension TabBarViewController {
    
    private func configTabBar() {
        tabBar.barTintColor = TabBarViewController.tabBarColor
        tabBar.isTranslucent = false
        
        if #available(iOS 10, *) {
            tabBar.tintColor = TabBarViewController.selectedTintColor
            tabBar.unselectedItemTintColor = TabBarViewController.tintColor
        } else {
            let textAttributes = [
                NSAttributedString.Key.foregroundColor : TabBarViewController.tintColor
            ]
            let selectedTextAttributes = [
                NSAttributedString.Key.foregroundColor : TabBarViewController.selectedTintColor
            ]
            UITabBarItem.appearance().setTitleTextAttributes(textAttributes, for: UIControl.State.normal)
            UITabBarItem.appearance().setTitleTextAttributes(selectedTextAttributes, for: UIControl.State.selected)
        }
        
    }
    
    private func popSelectedItemToRoot(_ item : UITabBarItem) {
        
        if let index = self.tabBar.items?.index(of: item) {
            if let selectedController = self.viewControllers?[index] as? UINavigationController {
                if selectedController.viewControllers.contains(where: { $0 is ContainerViewController
                }) {
                    selectedController.popToRootViewController(animated: false)
                }
            }
        }
    }

}
