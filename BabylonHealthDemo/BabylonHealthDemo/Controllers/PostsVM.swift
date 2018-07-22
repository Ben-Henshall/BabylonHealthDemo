import RxSwift
import RxCocoa
import CocoaLumberjackSwift

class PostsVM {
  private let disposeBag = DisposeBag()
  internal let navigationHandler: NavigationHandler
  internal let dataManager: DataManagerType
  
  public var alertStream: BehaviorSubject<AlertContents?>!

  public var title: Driver<String>!
  
  public var pullNewData: PublishSubject<Void>!
  
  public var postSelected: PublishSubject<Post>!

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
    alertStream = BehaviorSubject<AlertContents?>(value: nil)
    postSelected = PublishSubject<Post>()
    pullNewData = PublishSubject<Void>()

    title = Driver.just(NSLocalizedString("post_screen_title", comment: "Posts"))
    
    postSelected
      .subscribe(onNext: { [weak self] post in
        guard let strongSelf = self else { DDLogError("Attempted to transition to PostDetail when does not exist"); return }
        let viewModel = PostDetailVM(navigationHandler: strongSelf.navigationHandler, dataManager: strongSelf.dataManager, post: post)
        strongSelf.navigationHandler.transition(to: .postDetail(viewModel), type: .push, animated: true)
      })
      .disposed(by: disposeBag)
    
    pullNewData
      .flatMap { [weak self] _ -> Observable<[Post]> in
        guard let strongSelf = self else { return Observable.empty() }
        return strongSelf.dataManager.posts()
      }
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        let alert = AlertContents(title: NSLocalizedString("alert_error", comment: "Error"), text: error.localizedDescription, actionTitle: NSLocalizedString("alert_ok", comment: "OK"), action: nil)
        self?.alertStream.onNext(alert)
      })
      .subscribe(onNext: { [weak self] in
        self?.postsTimeline.onNext($0)
      })
      .disposed(by: disposeBag)
    
    pullNewData.onNext(())
  }
}
