import RxSwift
import RxCocoa
import CocoaLumberjackSwift

// TODO: Localise
// TODO: Add MARK comments
// TODO" Check for memory leaks
// TODO: Add refresh control

class PostsVM {
  private let disposeBag = DisposeBag()
  private let navigationHandler: NavigationHandler
  private let dataManager: DataManagerType
  
  public var alertStream: BehaviorSubject<AlertContents?>!

  public var title: Driver<String>!
  
  public var pullNewData: PublishSubject<Void>!
  
  private var postsTimeline: BehaviorSubject<[Post]>!
  public var posts: Driver<[Post]> {
    return postsTimeline.asDriver(onErrorJustReturn: [])
  }
  
  public var postSelected: PublishSubject<Post>!
  
  init(navigationHandler: NavigationHandler, dataManager: DataManagerType) {
    self.navigationHandler = navigationHandler
    self.dataManager = dataManager
    
    setup()
  }
  
  private func setup() {
    setupObservables()
    //pullNewData()
  }
  
  private func setupObservables() {
    postsTimeline = BehaviorSubject<[Post]>(value: [])
    alertStream = BehaviorSubject<AlertContents?>(value: nil)
    postSelected = PublishSubject<Post>()
    pullNewData = PublishSubject<Void>()

    title = Driver.just("Posts")
    
    postSelected
      .subscribe(onNext: { [weak self] post in
        guard let this = self else { DDLogError("Attempted to transition to PostDetail when does not exist"); return }
        let viewModel = PostDetailVM(navigationHandler: this.navigationHandler, dataManager: this.dataManager, post: post)
        this.navigationHandler.transition(to: .postDetail(viewModel), type: .push, animated: true)
      })
      .disposed(by: disposeBag)
    
    pullNewData
      .flatMap { [weak self] _ -> Observable<[Post]> in
        guard let this = self else { return Observable.empty() }
        return this.dataManager.posts()
      }
      .do(onError: { [weak self] error in
        // TODO: Implement user-friendly error codes
        let alert = AlertContents(title: "Error", text: error.localizedDescription, actionTitle: "OK", action: nil)
        self?.alertStream.onNext(alert)
      })
      .debug("pullNewData", trimOutput: true)
      .subscribe(onNext: { [weak self] in
        self?.postsTimeline.onNext($0)
      })
      .disposed(by: disposeBag)
    
    pullNewData.onNext(())
  }
}
