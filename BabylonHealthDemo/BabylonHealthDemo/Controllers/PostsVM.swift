import RxSwift
import RxCocoa

// TODO: Localise

class PostsVM {
  private let disposeBag = DisposeBag()
  private let navigationHandler: NavigationHandler
  private let dataManager: DataManagerType
  
  public var alertStream: PublishSubject<AlertContents?>!
  private var postsTimeline: BehaviorSubject<[Post]>!

  public var posts: Driver<[Post]> {
    return postsTimeline.asDriver(onErrorJustReturn: [])
  }
  
  init(navigationHandler: NavigationHandler, dataManager: DataManagerType) {
    self.navigationHandler = navigationHandler
    self.dataManager = dataManager
    
    setup()
  }
  
  private func setup() {
    setupObservables()
  }
  
  private func setupObservables() {
    postsTimeline = BehaviorSubject<[Post]>(value: [])
    alertStream = PublishSubject<AlertContents?>()

    pullNewData()
  }
  
  private func pullNewData() {
    // TODO: use `dataManager.posts(startingFrom: 0, limit: 5)` and `postsTimeline` with accumulator
    // operator to pull 5 posts, then 5 more each time the user hits a button/reaches end of tableView
    dataManager.posts()
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        self?.alertStream.onNext(AlertContents(title: "Error", text: error.localizedDescription, actionTitle: "OK", action: nil))
      })
      .subscribe(onNext: { [weak self] in
        self?.postsTimeline.onNext($0)
      })
      .disposed(by: disposeBag)
  }
  
  public func didPressCell() {
    pullNewData()
  }
}
