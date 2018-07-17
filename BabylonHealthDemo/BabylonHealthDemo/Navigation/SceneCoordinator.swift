import UIKit
import CocoaLumberjackSwift

/// Concrete implementation of NavigationHandler that provides navigation functionality between Scenes
/// Keeps references to ViewControllers to remove coupling between ViewControllers. ViewControllers are
/// completely independent of each other.
class SceneCoordinator: NSObject, NavigationHandler, UINavigationControllerDelegate {

  private let window: UIWindow
  private var currentViewController: UIViewController?

  init(window: UIWindow) {
    self.window = window
    currentViewController = window.rootViewController
  }
  
  func transition(to scene: Scene, type: SceneTransitionType, animated: Bool) {
    let newVC = scene.viewController()
    
    // If we're transitioning to a new navigation stack, update the delegate
    if let newVCNav = newVC as? UINavigationController {
      newVCNav.delegate = self
    }
    
    switch type {
    
      case .root:
        currentViewController = newVC.actualViewController
        window.rootViewController = newVC
      
      case .push:
        guard let navigationController = currentViewController?.navigationController else {
          fatalError("Can't push a view controller without a current navigation controller")
        }
        currentViewController = newVC.actualViewController
        // Safe force unwrap as we set currentViewController above
        navigationController.pushViewController(currentViewController!, animated: animated)
      
      case .modal:
        currentViewController?.navigationController?.present(newVC, animated: animated, completion: nil)
        currentViewController = newVC.actualViewController
    }
  }
  
  func pop(animated: Bool) {
    // Check if VC is being presented modally
    if let presentingVC = currentViewController?.presentingViewController, let isModal = currentViewController?.isModal(), isModal {
      
      currentViewController?.dismiss(animated: animated) {
        self.currentViewController = presentingVC.actualViewController
      }
      
    } else if let navigationController = currentViewController?.navigationController {
      
      guard navigationController.popViewController(animated: animated) != nil else {
        DDLogWarn("Can't navigate back from \(String(describing: currentViewController))")
        return
      }
      currentViewController = navigationController.viewControllers.last!.actualViewController
    } else {
      DDLogWarn("Not a modal, no navigation controller: can't navigate back from \(String(describing: currentViewController?.description))")
      return
    }
  }
  
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    // Update the current ViewController if navigation stack is updated without SceneCoordinator initiating the change.
    // e.g., navigating backwards using the system back button.
    currentViewController = viewController
  }
}
