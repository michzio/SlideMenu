//
//  SlideMenuViewController.swift
//  SlideMenu
//
//  Created by Michal Ziobro on 29/07/2019.
//  Copyright © 2019 Click5Interactive. All rights reserved.
//

import UIKit

public protocol SlideMenuDelegate {
    func slideMenuDidSelectItem(_ vc: SlideMenuViewController?, _ menuItemId: String)
    func slideMenuDidOpen(_ vc: SlideMenuViewController)
    func slideMenuDidClose()
    
    func slideMenuHeaderView(_ vc: SlideMenuViewController) -> UIView?
    func slideMenuFooterView(_ vc: SlideMenuViewController) -> UIView?
}

public extension SlideMenuDelegate {
    func slideMenuDidOpen(_ vc: SlideMenuViewController) { }
    func slideMenuDidClose() { }
    
    func slideMenuHeaderView(_ vc: SlideMenuViewController) -> UIView? { return nil }
    func slideMenuFooterView(_ vc: SlideMenuViewController) -> UIView? { return nil }
}

public protocol SlideMenuDataSource {
    
    var menuItems : [SlideMenuItem] { get }
    var signOutButtonTitle: NSAttributedString? { get }
    var loginButtonTitle: NSAttributedString? { get }
}

public extension SlideMenuDataSource {
    
    var menuItems : [SlideMenuItem] {
        return []
    }
    
    var signOutButtonTitle: NSAttributedString? {
        return nil
    }
    
    var loginButtonTitle: NSAttributedString? {
        return nil
    }
    
}

open class SlideMenuViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet public weak var closeOverlayButton: UIButton!
    @IBOutlet public weak var slideMenuView: UIView!
    
    @IBOutlet public weak var topSafeAreaFillView: UIView!
    @IBOutlet public weak var headerView: UIView!
    @IBOutlet public weak var footerView: UIView!
    @IBOutlet public weak var bottomSafeAreaFillView: UIView!
    
    @IBOutlet public weak var closeButton: UIButton!
    @IBOutlet public weak var signOutButton: UIButton!
    
    @IBOutlet public var tableView: UITableView!
    
    // MARK: - Views
    lazy var dimView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Constraints
    @IBOutlet weak var slideMenuTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var footerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Delegate & Data Source
    public var delegate : SlideMenuDelegate?
    public var dataSource : SlideMenuDataSource?
    
    
    public var isHiddenSignOutButton: Bool = false {
        didSet {
            signOutButton.isHidden = isHiddenSignOutButton
        }
    }
    
    // MARK: - Model
    open var menuItems: [SlideMenuItem] {
        return dataSource?.menuItems ?? SlideMenuModel.example
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        configStyle()
        configSwipeGesture()
        configActions()
        configTableView()
        configHeaderView()
        configFooterView()
        
        refreshData()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dimView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    override open var prefersStatusBarHidden: Bool {
        
        guard DeviceType.IS_IPHONE_X_XS || DeviceType.IS_IPHONE_XR_XS_MAX else { return false }
        
        return self.isOpen == true
    }
    
    @objc func didTapClose(_ button: UIButton) {
        self.closeSlideMenu()
    }
    
    @objc func didTapSignOut(_ button: UIButton) {
        delegate?.slideMenuDidSelectItem(self, SlideMenuItem.Labels.SignOut.rawValue)
        self.closeSlideMenu()
    }
    
    @objc func didSwipeToClose(_ recognizer: UISwipeGestureRecognizer) {
        self.closeSlideMenu()
    }
    
    open func refreshData() {
        // to override
        
        self.signOutButton.isHidden = true
        if isLoggedIn && !isHiddenSignOutButton{
            
            // change to "sign out" button
            signOutButton.isHidden = false
            signOutButton.setAttributedTitle(signOutButtonTitle, for: .normal)
            
        } else {
            
            // change to "login" button
            signOutButton.isHidden = false
            signOutButton.setAttributedTitle(loginButtonTitle, for: .normal)
        }
    }
    
    open var isLoggedIn : Bool {
        return false
    }
    
    
    open var signOutButtonTitle: NSAttributedString {
        
        let title = NSAttributedString(
            string: "Sign Out",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        )
        
        return dataSource?.signOutButtonTitle ?? title
    }
    
    open var loginButtonTitle: NSAttributedString {
        
        let title = NSAttributedString(
            string: "Log In",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.black
            ]
        )
        
        return dataSource?.loginButtonTitle ?? title
    }
    
    open func configStyle() {
        
        //  Slide Menu
        slideMenuView.layer.shadowColor = UIColor.black.cgColor
        slideMenuView.layer.shadowOpacity = 0.4
        slideMenuView.layer.shadowOffset = CGSize.zero
        slideMenuView.layer.shadowRadius = 6
        slideMenuView.layer.shadowPath = UIBezierPath(rect: (slideMenuView?.bounds)!).cgPath
        slideMenuView.backgroundColor = .white
        
        // Menu Header
        topSafeAreaFillView.backgroundColor = UIColor.lightGray
        headerView.backgroundColor = UIColor.lightGray
        footerView.backgroundColor = UIColor.lightGray
        bottomSafeAreaFillView.backgroundColor = UIColor.lightGray
        
        // Close Button
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(closeImage, for: .normal)
        closeButton.setImage(closeImage.colored(.darkGray), for: .highlighted)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        // Sign Out Button
        signOutButton.backgroundColor = UIColor.lightGray
        
    }
    
    open func configHeaderView() {
        
        if let view = delegate?.slideMenuHeaderView(self) {
        
            let size = view.systemLayoutSizeFitting(CGSize(width: headerView.bounds.width, height: 100))
            headerViewHeightConstraint.constant = size.height
            
            headerView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            view.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
            
        } else {
            headerViewHeightConstraint.constant = 0
        }
    }
    
    open func configFooterView() {
        
        if let view = delegate?.slideMenuFooterView(self) {
            
            let size = view.systemLayoutSizeFitting(CGSize(width: footerView.bounds.width, height: 100))
            footerViewHeightConstraint.constant = size.height
            
            footerView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            view.leadingAnchor.constraint(equalTo: footerView.leadingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: footerView.topAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: footerView.trailingAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
            
        } else {
            footerViewHeightConstraint.constant = 0
        }
    }
}

// MARK: - PUBLIC METHODS
extension SlideMenuViewController {
    
    public func openSlideMenu(over viewController: UIViewController?, completion: ((Bool) -> Void)? = nil) {
        
        guard let parent = viewController?.tabBarController ??
                           viewController?.navigationController ??
            viewController else { completion?(false); return }
        
        parent.addChild(self)
        
        self.beginAppearanceTransition(true, animated: true)
        
        parent.view.addSubview(dimView)
        parent.view.addSubview(self.view)
        
        constraint(child: self, in: parent)
        
        slideMenuTrailingConstraint.constant = -slideMenuView.bounds.width
        self.view.layoutIfNeeded()
        
        slideMenuTrailingConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.dimView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        }, completion: { success in
            self.endAppearanceTransition()
            self.setNeedsStatusBarAppearanceUpdate()
            
            self.didMove(toParent: parent)
            
            completion?(true)
            self.delegate?.slideMenuDidOpen(self)
        })
    }
    
    public func closeSlideMenu() {
        
        slideMenuTrailingConstraint.constant = -slideMenuView.bounds.width
        self.setNeedsStatusBarAppearanceUpdate()
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.dimView.backgroundColor = .clear
            self.view.layoutIfNeeded()
            
        }, completion: { (finished) in
            
            self.view.removeFromSuperview()
            self.dimView.removeFromSuperview()
            self.removeFromParent()
            
            self.delegate?.slideMenuDidClose()
        })
    }
    
    public var isOpen : Bool {
        return self.slideMenuTrailingConstraint.constant == 0
    }
}

// MARK: - PRIVATE METHODS
extension SlideMenuViewController {
    
    private func configActions() {
        closeButton.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
        closeOverlayButton.addTarget(self, action: #selector(didTapClose(_:)), for: .touchUpInside)
        
        signOutButton.addTarget(self, action: #selector(didTapSignOut(_:)), for: .touchUpInside)
    }
    
    private func configSwipeGesture() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeToClose(_:)))
        swipe.direction = .right
        self.view.addGestureRecognizer(swipe)
    }
    
    private func constraint(child: UIViewController, in parent: UIViewController) {
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.topAnchor.constraint(equalTo: parent.view.topAnchor, constant: -28).isActive = true
        child.view.bottomAnchor.constraint(equalTo: parent.view.bottomAnchor, constant: 0).isActive = true
        child.view.trailingAnchor.constraint(equalTo: parent.view.trailingAnchor, constant: 0).isActive = true
        child.view.leadingAnchor.constraint(equalTo: parent.view.leadingAnchor, constant: 0).isActive = true
        
        if #available(iOS 11.0, *) {
            child.additionalSafeAreaInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        } else {
            // Fallback on earlier versions
        }
    }
}

// MARK: - Slide Menu - Table View
extension SlideMenuViewController : UITableViewDataSource, UITableViewDelegate {
 
    private func configTableView() {
    
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: SlideMenuOptionTableViewCell.identifier, bundle: Bundle(for: SlideMenuViewController.self)), forCellReuseIdentifier: SlideMenuOptionTableViewCell.identifier)
        
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SlideMenuOptionTableViewCell.identifier) as! SlideMenuOptionTableViewCell
        
        cell.iconImageView.image = menuItems[indexPath.row].icon
        cell.titleLabel.text = menuItems[indexPath.row].title
        
        let item = menuItems[indexPath.row]
        if item.badge != nil {
            cell.badgeLabel.text = "\(item.badge!)"
            cell.badgeLabel.isHidden = false
        } else {
            cell.badgeLabel.isHidden = true
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let menuItemId = menuItems[indexPath.row].id
        self.delegate?.slideMenuDidSelectItem(self, menuItemId)
        self.view.isHidden = true
        self.closeSlideMenu()
    }
}

extension SlideMenuViewController {
    
    class var OffScreenFrame : CGRect {
        return CGRect(x: UIScreen.main.bounds.width, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    class var OnScreenFrame : CGRect {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}

extension SlideMenuViewController {
    
    private var closeImage : UIImage {
        return UIImage(named: "close", in: Bundle(for: SlideMenuViewController.self), compatibleWith: nil)!
    }
}
