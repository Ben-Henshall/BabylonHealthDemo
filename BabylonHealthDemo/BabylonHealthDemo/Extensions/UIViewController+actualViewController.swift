import UIKit

extension UIViewController {
  
  public var actualViewController: UIViewController {
    if let navigationController = self as? UINavigationController {
      return navigationController.viewControllers.first!
    } else {
      return self
    }
  }
}
