import UIKit

/// Concrete implementation of NavigationHandler that provides navigation functionality between Scenes
class SceneCoordinator: NavigationHandler {

  private let window: UIWindow
  private var currentViewController: UIViewController

  init(window: UIWindow) {
    self.window = window
    currentViewController = window.rootViewController!
  }
  
  func transition(to scene: Scene, type: SceneTransitionType, animated: Bool) {
    let newVC = scene.viewController()
    
    switch type {
    
      case .root:
        currentViewController = newVC.actualViewController
        window.rootViewController = newVC
      
      case .push:
        guard let navigationController = currentViewController.navigationController else {
          fatalError("Can't push a view controller without a current navigation controller")
        }
        currentViewController = newVC.actualViewController
        navigationController.pushViewController(newVC, animated: animated)
      
      case .modal:
        currentViewController = newVC.actualViewController
        currentViewController.present(newVC, animated: animated, completion: nil)
    }
  }
  
  func pop(animated: Bool) {
    // Check if VC is being presented modal
    if let presentingVC = currentViewController.presentingViewController, currentViewController.isModal() {
      // dismiss the modal controller
      currentViewController.dismiss(animated: animated) {
        self.currentViewController = presentingVC.actualViewController
      }
    } else if let navigationController = currentViewController.navigationController {
      
      guard navigationController.popViewController(animated: animated) != nil else {
        fatalError("Can't navigate back from \(currentViewController)")
      }
      currentViewController = navigationController.viewControllers.last!.actualViewController
    } else {
      fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
    }
  }
}
