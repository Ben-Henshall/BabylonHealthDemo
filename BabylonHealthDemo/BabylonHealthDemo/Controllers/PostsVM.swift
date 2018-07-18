import RxSwift
import RxCocoa

class PostsVM {
  var testText = "first edition"
  
  private let navigationHandler: NavigationHandler
  private let dataAccessor: DataAccessor
  
  public var posts: Driver<[Post]>!
  
  init(navigationHandler: NavigationHandler, dataAccessor: DataAccessor) {
    self.navigationHandler = navigationHandler
    self.dataAccessor = dataAccessor
    
    setup()
  }
  
  private func setup() {
    setupObservables()
  }
  
  private func setupObservables() {
    posts = dataAccessor.cached.posts()
  }
}
