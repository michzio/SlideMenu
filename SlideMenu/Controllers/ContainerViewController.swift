//
//  ContainerViewController.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 29/07/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

protocol ContainerViewControllerChildProtocol {
    
    func setNavigationItems()
    var shouldEnableNavigationControllerToPopContainerViewControllerWhileDisappearing : Bool { get }
}

extension ContainerViewControllerChildProtocol {
    
    func setNavigationItems() { }
    
    var shouldEnableNavigationControllerToPopContainerViewControllerWhileDisappearing : Bool {
        return true
    }
}

class ContainerViewController : SlideMenuBaseViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    public private(set) var contentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configBarButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        (self.tabBarController as? TabBarViewController)?.highlightSelectedItem(false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        func isPoppable() -> Bool {
            if let child = self.contentViewController as? ContainerViewControllerChildProtocol {
                return child.shouldEnableNavigationControllerToPopContainerViewControllerWhileDisappearing
            }
            return true
        }
        
        if isPoppable() { // self.presentedViewController == nil {
            _ = self.navigationController?.popViewController(animated: false)
        }
    }
}

// MARK: - PUBLIC METHODS
extension ContainerViewController {
    
    func setContentView(viewController: UIViewController, timeInterval: TimeInterval = 0.25, transition direction: TransitionDirection = .forward, completion: ((Bool) -> Void)? = nil) {
    
        configBarButtons()
        
        let oldViewController = self.contentViewController
        
        ViewEmbedder(container: containerView, in: self)
            .setTransitionDirection(direction: direction)
            .setTimeInterval(timeInterval)
            .embed(child: viewController, replacing: oldViewController) {
                
                self.contentViewController = viewController
                if let containerChildVC = viewController as? ContainerViewControllerChildProtocol {
                    containerChildVC.setNavigationItems()
                    completion?(true)
                }
        }
    }
}

// MARK: - PRIVATE METHODS
extension ContainerViewController {
    
    private func configBarButtons() {
        addSlideMenuBarButton()
        addCustomBackBarButton()
    }
}


