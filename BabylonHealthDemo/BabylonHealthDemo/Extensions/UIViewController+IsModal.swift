import UIKit

extension UIViewController {
  
  /// Returns whether or not the viewController is being presented modally
  ///
  /// - Returns: Whether the ViewController is being presented modally
  func isModal() -> Bool {
    // Check if VC is the root view controller
    if let index = navigationController?.viewControllers.index(of: self), index > 0 {
      return false
    } else if self.presentingViewController != nil {
      return true
    } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
      return true
    } else if self.tabBarController?.presentingViewController is UITabBarController {
      return true
    }
    
    return false
  }
}
