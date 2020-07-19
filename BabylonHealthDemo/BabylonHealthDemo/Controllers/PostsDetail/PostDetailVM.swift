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
      .map { $0.first }
      .share(replay: 1, scope: .whileConnected)
    
    setup()
  }
  
  private func setup() {
    setupObservables()
  }
  
  private func setupObservables() {
    alertStream = PublishSubject<AlertContents?>()
    title = Driver.just(NSLocalizedString("post_detail_screen_title", comment: "Post Detail"))
    
    authorCellTitle = Driver.just(NSLocalizedString("post_detail_screen_author", comment: "Author"))

    author = post
      // Only take the first post, as the userID won't change and taking 1 will prevent making
      // multiple network requests
      .take(1)
      .flatMap { [weak self] postObj -> Observable<[User]> in
        guard let strongSelf = self else { return Observable.empty() }
        return strongSelf.dataManager.user(id: postObj.userID)
      }
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        self?.alertStream.onNext(AlertContents(title: NSLocalizedString("alert_error", comment: "Error"), text: error.localizedDescription, actionTitle: NSLocalizedString("alert_ok", comment: "OK"), action: nil))
      })
      .filter(\.isEmpty)
      .map { $0.first?.username ?? "" }
      .asDriver(onErrorJustReturn: "")
    
    bodyCellTitle = Driver.just(NSLocalizedString("post_detail_screen_body", comment: "Body"))
    body = post
      .map { $0.body }
      .asDriver(onErrorJustReturn: "")
    
    comments = post
      // Only take the first post, as the userID won't change and taking 1 will prevent making
      // multiple network requests
      .take(1)
      .flatMap { [weak self] postObj -> Observable<[Comment]> in
        guard let strongSelf = self else { return Observable.empty() }
        return strongSelf.dataManager.comments(on: postObj.id)
      }
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        self?.alertStream.onNext(AlertContents(title: NSLocalizedString("alert_error", comment: "Error"), text: error.localizedDescription, actionTitle: NSLocalizedString("alert_ok", comment: "OK"), action: nil))
      })
      .asDriver(onErrorJustReturn: [])
    
    numberOfCommentsCellTitle = Driver.just(NSLocalizedString("post_detail_screen_num_of_comments", comment: "Number of comments"))
    numberOfComments = comments
      .map { $0.count }
    
    // Subscription to kick off networking
    self.post
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        self?.alertStream.onNext(AlertContents(title: NSLocalizedString("alert_error", comment: "Error"), text: error.localizedDescription, actionTitle: NSLocalizedString("alert_ok", comment: "OK"), action: nil))
      })
      .subscribe()
      .disposed(by: disposeBag)
  }
}