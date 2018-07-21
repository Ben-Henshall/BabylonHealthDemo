import RxSwift
import RxCocoa

// TODO: Localise

class PostsVM {
  private let disposeBag = DisposeBag()
  private let navigationHandler: NavigationHandler
  private let dataManager: DataManager
  
  public var posts: Driver<[Post]> {
    return postsTimeline.asDriver(onErrorJustReturn: [])
  }
  
  public var alertStream: PublishSubject<AlertContents?>!
  
  init(navigationHandler: NavigationHandler, dataManager: DataManager) {
    self.navigationHandler = navigationHandler
    self.dataManager = dataManager
    
    setup()
  }
  
  private func setup() {
    setupObservables()
  }
  
  var postsTimeline: BehaviorSubject<[Post]>!
  
  private func setupObservables() {
    postsTimeline = BehaviorSubject<[Post]>(value: [])
    alertStream = PublishSubject<AlertContents?>()
    
    pullNewData()
  }
  
  private func pullNewData() {
    // TODO: use `dataManager.posts(startingFrom: 0, limit: 5)` and `postsTimeline` with accumulator
    // operator to pull 5 posts, then 5 more each time the user hits a button/reaches end of tableView
    dataManager.posts(startingFrom: 10, limit: 2)
      .debug("posts", trimOutput: true)
      .do(onError: { [weak self] error in
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
