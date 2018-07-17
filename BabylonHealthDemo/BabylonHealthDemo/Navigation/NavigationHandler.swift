/// Handler protocol used to navigate between scenes
protocol NavigationHandler {

  /// Transitions the app into the specified scene, using a specified transition type
  ///
  /// - Parameters:
  ///   - scene: The Scene to transition to
  ///   - type: The type of transition (e.g. push) to use when transitioning to the scene
  ///   - animated: If the transition should be animated
  func transition(to scene: Scene, type: SceneTransitionType, animated: Bool)

  /// Pops the most recent Scene off of the navigation stack
  func pop(animated: Bool)
}
