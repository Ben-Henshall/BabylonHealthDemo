import RxSwift
import RxCocoa

class PostsVM {
  private let disposeBag = DisposeBag()
  private let navigationHandler: NavigationHandler
  private let dataManager: DataManager
  
  public var posts: Driver<[Post]> {
    return postsTimeline.debug("postsTimeline", trimOutput: true)
      .asDriver(onErrorJustReturn: [])
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
    dataManager.posts()
      .debug("dataManagerPosts", trimOutput: true)
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
