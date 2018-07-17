/// Represents the transitions available between scenes
enum SceneTransitionType {
  case root   // Make view controller the root view controller
  case push   // Push view controller to navigation stack
  case modal  // Present view controller modally
}
