import RxSwift
import RxCocoa
import CocoaLumberjackSwift

class PostsVM {
  private let disposeBag = DisposeBag()
  internal let navigationHandler: NavigationHandler
  internal let dataManager: DataManagerType
  
  // MARK: - Output
  public var alertStream: BehaviorSubject<AlertContents?>!
  public var title: Driver<String>!
  
  private var postsTimeline: BehaviorSubject<[Post]>!
  public var posts: Driver<[Post]> {
    return postsTimeline.asDriver(onErrorJustReturn: [])
  }
  
  // MARK: - Input
  public var pullNewData: PublishSubject<Void>!
  public var postSelected: PublishSubject<Post>!
  
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

    title = Driver.just(Localization.Posts.title)
    
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
        self?.alertStream.onNext(AlertContents(error: error))
      })
      .subscribe(onNext: postsTimeline.onNext)
      .disposed(by: disposeBag)
    
    pullNewData.onNext(())
  }
}
