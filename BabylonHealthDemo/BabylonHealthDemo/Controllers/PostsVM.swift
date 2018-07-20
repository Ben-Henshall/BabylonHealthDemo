import RxSwift
import RxCocoa

class PostsVM {
  var testText = "first edition"
  
  private let navigationHandler: NavigationHandler
  private let dataManager: DataManager
  
  public var posts: Driver<[Post]>!
  
  init(navigationHandler: NavigationHandler, dataManager: DataManager) {
    self.navigationHandler = navigationHandler
    self.dataManager = dataManager
    
    setup()
  }
  
  private func setup() {
    setupObservables()
  }
  
  private func setupObservables() {
    //posts = dataManager.posts().asDriver(onErrorJustReturn: [])
    posts = dataManager.posts(startingFrom: 10, limit: 5).asDriver(onErrorJustReturn: [])
  }
}
