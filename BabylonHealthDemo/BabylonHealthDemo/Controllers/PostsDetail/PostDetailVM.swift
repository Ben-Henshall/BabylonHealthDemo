import RxSwift
import RxCocoa

class PostDetailVM {
  private let disposeBag = DisposeBag()
  private let navigationHandler: NavigationHandler
  private let dataManager: DataManagerType
  
  private var post: Observable<Post>!

  // MARK: - Output
  public var alertStream: PublishSubject<AlertContents?>!
  public var title: Driver<String>!
  public var authorCellTitle: Driver<String>!
  public var author: Driver<String>!
  public var bodyCellTitle: Driver<String>!
  public var body: Driver<String>!
  public var comments: Driver<[Comment]>!
  public var numberOfCommentsCellTitle: Driver<String>!
  public var numberOfComments: Driver<Int>!
  
  init(navigationHandler: NavigationHandler, dataManager: DataManagerType, post: Post) {
    self.navigationHandler = navigationHandler
    self.dataManager = dataManager
    
    self.post = dataManager.post(id: post.id)
      .compactMap(\.first)
      .share(replay: 1, scope: .whileConnected)
    
    setup()
  }
  
  private func setup() {
    setupObservables()
  }
  
  private func setupObservables() {
    alertStream = PublishSubject<AlertContents?>()
    title = Driver.just(Localization.PostDetail.title)
    
    authorCellTitle = Driver.just(Localization.PostDetail.author)

    author = post
      .observeOn(MainScheduler.asyncInstance)
      // Only take the first post, as the userID won't change and taking 1 will prevent making
      // multiple network requests
      .take(1)
      .flatMap { [weak self] postObj -> Observable<[User]> in
        guard let strongSelf = self else { return Observable.empty() }
        return strongSelf.dataManager.user(id: postObj.userID)
      }
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        self?.alertStream.onNext(AlertContents(error: error))
      })
      .filter(\.isEmpty.isFalse)
      .compactMap(\.first?.username)
      .asDriver(onErrorJustReturn: "")
    
    bodyCellTitle = Driver.just(Localization.PostDetail.body)
    body = post
      .map(\.body)
      .asDriver(onErrorJustReturn: "")
    
    comments = post
      .observeOn(MainScheduler.asyncInstance)
      // Only take the first post, as the userID won't change and taking 1 will prevent making
      // multiple network requests
      .take(1)
      .flatMap { [weak self] postObj -> Observable<[Comment]> in
        guard let strongSelf = self else { return Observable.empty() }
        return strongSelf.dataManager.comments(on: postObj.id)
      }
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        self?.alertStream.onNext(AlertContents(error: error))
      })
      .asDriver(onErrorJustReturn: [])
    
    numberOfCommentsCellTitle = Driver.just(Localization.PostDetail.numberOfComments)
    numberOfComments = comments
      .map(\.count)
    
    // Subscription to kick off networking
    self.post
      .observeOn(MainScheduler.asyncInstance)
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        self?.alertStream.onNext(AlertContents(error: error))
      })
      .subscribe()
      .disposed(by: disposeBag)
  }
}
