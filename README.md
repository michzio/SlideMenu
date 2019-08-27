It is important to add 

    extension SomeMenuSelectableViewController : ContainerViewControllerChildProtocol {


        var shouldEnableNavigationControllerToPopContainerViewControllerWhileDisappearing: Bool {
        return false
        }
    }
    
to enable in-depth navigation down the navigation branch via pushing new child view controllers.
