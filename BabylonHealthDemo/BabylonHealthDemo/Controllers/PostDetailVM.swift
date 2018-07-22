import RxSwift
import RxCocoa

class PostDetailVM {
  private let disposeBag = DisposeBag()
  private let navigationHandler: NavigationHandler
  private let dataManager: DataManagerType
  
  public var alertStream: PublishSubject<AlertContents?>!
  public var title: Driver<String>!
  public var authorCellTitle: Driver<String>!
  public var author: Driver<String>!
  public var bodyCellTitle: Driver<String>!
  public var body: Driver<String>!
  public var comments: Driver<[Comment]>!
  public var numberOfCommentsCellTitle: Driver<String>!
  public var numberOfComments: Driver<Int>!
  
  private var post: Observable<Post>!

  init(navigationHandler: NavigationHandler, dataManager: DataManagerType, post: Post) {
    self.navigationHandler = navigationHandler
    self.dataManager = dataManager
    
    self.post = dataManager.post(id: post.id)
      .map { $0.first! }
      .share(replay: 1, scope: .whileConnected)

    // Subscription to kick off networking
    self.post
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        self?.alertStream.onNext(AlertContents(title: "Error", text: error.localizedDescription, actionTitle: "OK", action: nil))
      })
      .subscribe()
      .disposed(by: disposeBag)
    
    setup()
  }
  
  private func setup() {
    setupObservables()
  }
  
  private func setupObservables() {
    alertStream = PublishSubject<AlertContents?>()
    title = Driver.just("Post Detail")
    
    authorCellTitle = Driver.just("Author")
    // TODO: Change Single retrievals to not retrieve array
    author = post
      // Only take the first post, as the userID won't change and taking 1 will prevent making
      // multiple network requests
      .take(1)
      .flatMap { [weak self] postObj -> Observable<[User]> in
        guard let this = self else { return Observable.empty() }
        return this.dataManager.user(id: postObj.userID)
      }
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        self?.alertStream.onNext(AlertContents(title: "Error", text: error.localizedDescription, actionTitle: "OK", action: nil))
      })
      .filter { !$0.isEmpty}
      .debug("author", trimOutput: true)
      .map { $0.first! }
      .map { $0.username }
      .asDriver(onErrorJustReturn: "")
    
    bodyCellTitle = Driver.just("Body")
    body = post
      .map { $0.body }
      .asDriver(onErrorJustReturn: "")
    
    comments = post
      // Only take the first post, as the userID won't change and taking 1 will prevent making
      // multiple network requests
      .take(1)
      .flatMap { [weak self] postObj -> Observable<[Comment]> in
        guard let this = self else { return Observable.empty() }
        return this.dataManager.comments(on: postObj.id)
      }
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        self?.alertStream.onNext(AlertContents(title: "Error", text: error.localizedDescription, actionTitle: "OK", action: nil))
      })
      .asDriver(onErrorJustReturn: [])
    
    numberOfCommentsCellTitle = Driver.just("Number of comments")
    numberOfComments = comments
      .map { $0.count }
  }
}
