struct PostsVM {
  var testText = "first edition"
  
  private let navigationHandler: NavigationHandler
  
  init(navigationHandler: NavigationHandler) {
    self.navigationHandler = navigationHandler
  }
  
  public func pop() {
    navigationHandler.pop(animated: true)
  }
  
  public func root() {
    let newViewModel = PostsVM(navigationHandler: navigationHandler)
    navigationHandler.transition(to: .postsEmbedded(newViewModel), type: .root, animated: true)
  }
  
  public func push() {
    let newViewModel = PostsVM(navigationHandler: navigationHandler)
    navigationHandler.transition(to: .posts(newViewModel), type: .push, animated: true)
  }
  
  public func modal() {
    let newViewModel = PostsVM(navigationHandler: navigationHandler)
    navigationHandler.transition(to: .postsEmbedded(newViewModel), type: .modal, animated: true)
  }
}
