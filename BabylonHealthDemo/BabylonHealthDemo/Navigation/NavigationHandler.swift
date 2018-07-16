/// Handler protocol used to navigate between scenes
protocol NavigationHandler {

  /// Pushes the scene onto the navigation stack
  ///
  /// - Parameter scene: The scene to push onto the navigation stack
  func transition(to scene: Scene, type: SceneTransitionType, animated: Bool)

  /// Pops the most recent scene off of the navigation stack
  func pop(animated: Bool)
}
