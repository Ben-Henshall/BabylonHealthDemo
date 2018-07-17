/// Abstraction of an app "Scene". Each case represents a ViewController/screen of the app.
/// If the ViewController can be accessed through both pushing onto the navigation stack
/// and presenting/making the root ViewController, then two cases are required due to
/// one being accessed as the actual view controller and one being embedded in a navigation controller.

/// The associated value is the ViewModel used to power the scene being transitioned to.
enum Scene {
  // Posts VC
  case posts(PostsVM)
  
  // Posts VC, embedded in a navigation controller
  case postsEmbedded(PostsVM)
}
