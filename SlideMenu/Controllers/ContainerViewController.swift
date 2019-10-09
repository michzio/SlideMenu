//
//  ContainerViewController.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 29/07/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

public protocol ContainerViewControllerChildProtocol {
    
    func setNavigationItems()
    var shouldEnableNavigationControllerToPopContainerViewControllerWhileDisappearing : Bool { get }
}

public extension ContainerViewControllerChildProtocol {
    
    func setNavigationItems() { }
    
    var shouldEnableNavigationControllerToPopContainerViewControllerWhileDisappearing : Bool {
        return true
    }
}

open class ContainerViewController : SlideMenuBaseViewController {
    
    //@IBOutlet weak var containerView: UIView!
    var containerView: UIView!
    var bottomSafeAreaView: UIView!
    
    public private(set) var contentViewController: UIViewController?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        configBarButtons()
        configContainerView()
        configBottomSafeAreaView()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        (self.tabBarController as? TabBarViewController)?.highlightSelectedItem(false)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
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
            .embed(child: viewController, replacing: oldViewController) { [weak self] in
                guard let self = self else { return }
                
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
    
    private func configContainerView() {
        
        self.containerView = createContainerView()
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: containerToSafeArea ? view.safeLeadingAnchor : view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: containerToSafeArea ? view.safeTrailingAnchor : view.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: containerToSafeArea ? view.safeTopAnchor : view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: containerToSafeArea ? view.safeBottomAnchor : view.bottomAnchor).isActive = true
    }
    
    private func configBottomSafeAreaView() {
        
        self.bottomSafeAreaView = createBottomSafeAreaView()
        view.addSubview(bottomSafeAreaView)
        
        bottomSafeAreaView.translatesAutoresizingMaskIntoConstraints = false
        bottomSafeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        bottomSafeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        bottomSafeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        bottomSafeAreaView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
        
    }
}


