class DetailVM {
  var testText = "first edition"
  
  let navigationHandler: NavigationHandler
  
  init(navigationHandler: NavigationHandler) {
    self.navigationHandler = navigationHandler
  }
  
  public func pop() {
    navigationHandler.pop(animated: true)
  }
}
