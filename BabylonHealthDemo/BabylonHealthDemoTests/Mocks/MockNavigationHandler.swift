@testable import BabylonHealthDemo

/// Model for information on a transition been performed.
public struct MockTransitionInfo {
  public var scene: Scene
  public var type: SceneTransitionType
  public var animated: Bool
}

/// Extension to retrieve the viewModel from the Scene
extension Scene {
  public func viewModel() -> Any {
    switch self {
    case .posts(let viewModel):
      return viewModel
    case .postsEmbedded(let viewModel):
      return viewModel
    }
  }
}

/// Mock class for simulating navigating between scenes.
class MockNavigationHandler: NavigationHandler {
  
  // Stores the latest transition info
  public var transitionInfo: MockTransitionInfo?
  
  // Nil if no pop occured, then true/false if it's animated and occurs
  public var didPopAnimated: Bool?
  
  func transition(to scene: Scene, type: SceneTransitionType, animated: Bool) {
    transitionInfo = MockTransitionInfo(scene: scene, type: type, animated: animated)
  }
  
  func pop(animated: Bool) {
    self.didPopAnimated = animated
  }
}
