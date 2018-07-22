import RxSwift
import RxCocoa

class PostDetailVM {
  private let disposeBag = DisposeBag()
  private let navigationHandler: NavigationHandler
  private let dataManager: DataManagerType
  private let post: Post
  
  public var alertStream: PublishSubject<AlertContents?>!
  
  public var title: Driver<String>!
  public var author: Driver<String>!
  
  private var postsTimeline: BehaviorSubject<[Post]>!
  public var posts: Driver<[Post]> {
    return postsTimeline.asDriver(onErrorJustReturn: [])
  }
  
  init(navigationHandler: NavigationHandler, dataManager: DataManagerType, post: Post) {
    self.navigationHandler = navigationHandler
    self.dataManager = dataManager
    self.post = post
    
    setup()
  }
  
  private func setup() {
    setupObservables()
  }
  
  private func setupObservables() {
    postsTimeline = BehaviorSubject<[Post]>(value: [])
    alertStream = PublishSubject<AlertContents?>()
    title = Driver.just("Post Detail")
    // TODO: Change Single retrievals to not retrieve array
    author = dataManager.user(id: post.userID)
      .map { $0.first!.username }
      .asDriver(onErrorJustReturn: "Author")
  }
}
