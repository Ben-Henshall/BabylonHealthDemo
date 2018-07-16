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
    // TODO: Fix navigation
  }
  
  func pop() {
    // TODO: Pop
  }
}
