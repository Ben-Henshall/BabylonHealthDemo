import UIKit

extension UIViewController {
  
  /// Retrieves a UIViewController from within a NavigtionConroller, else returns the ViewController
  public var actualViewController: UIViewController {
    if let navigationController = self as? UINavigationController {
      return navigationController.viewControllers.first!
    } else {
      return self
    }
  }
}
