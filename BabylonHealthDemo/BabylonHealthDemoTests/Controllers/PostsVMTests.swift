import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import BabylonHealthDemo

class PostsVMTests: XCTestCase {
  
  private var disposeBag = DisposeBag()
  private var navigationHandler: MockNavigationHandler!
  private var dataManager: MockDataManager!
  private var vm: PostsVM!
  private var scheduler: TestScheduler!
  
  private var postsSubject: PublishSubject<[Post]>!
  private var usersSubject: PublishSubject<[User]>!
  private var commentsSubject: PublishSubject<[Comment]>!
  
  override func setUp() {
    super.setUp()
    scheduler = TestScheduler(initialClock: 0)

    postsSubject = PublishSubject<[Post]>()
    usersSubject = PublishSubject<[User]>()
    commentsSubject = PublishSubject<[Comment]>()
    
    navigationHandler = MockNavigationHandler()
    dataManager = MockDataManager(
      posts: postsSubject.asObservable(),
      users: usersSubject.asObservable(),
      comments: commentsSubject.asObservable()
    )

    vm = PostsVM(navigationHandler: navigationHandler, dataManager: dataManager)
  }
  
  override func tearDown() {
    super.tearDown()
    disposeBag = DisposeBag()
  }
  
  func testIsTitleCorrect() {
    let expected = "Posts"
    guard let text = try? vm.title.toBlocking().first()! else { XCTFail(); return }
    XCTAssertEqual(expected, text)
  }
  
  func testDoesPostsUpdate() {
    let firstExpected: [Post] = []
    let secondExpected = [Post(id: 1, userID: 1, title: "title1", body: "body1")]
    let thirdExpected = [
      Post(id: 1, userID: 1, title: "title1", body: "body1"),
      Post(id: 2, userID: 2, title: "title2", body: "body2")
    ]
    
    let postsEvents = scheduler.createObserver([Post].self)
    vm.posts
      .drive(postsEvents)
      .disposed(by: disposeBag)
    
    scheduler.scheduleAt(100) { [unowned self] in
      self.postsSubject.onNext(secondExpected)
    }
    scheduler.scheduleAt(200) { [unowned self] in
      self.postsSubject.onNext(thirdExpected)
    }
    scheduler.start()
    
    let expected = [
      Recorded.next(0, firstExpected),
      Recorded.next(100, secondExpected),
      Recorded.next(200, thirdExpected)
    ]

    XCTAssertEqual(expected, postsEvents.events)
  }
  
  func testDoesFetchErrorEmitAlert() {
    let alertEvents = scheduler.createObserver(AlertContents?.self)
    vm.alertStream
      .bind(to: alertEvents)
      .disposed(by: disposeBag)
    
    let error = RxError.unknown
    scheduler.scheduleAt(100) { [unowned self] in
      self.postsSubject.onError(error)
    }
    scheduler.start()
    
    let expected = [
      Recorded.next(0, (nil as AlertContents?)),
      Recorded.next(100, (AlertContents(title: "Error", text: error.localizedDescription, actionTitle: "OK", action: nil)) as AlertContents?)
    ]
    
    XCTAssertEqual(expected, alertEvents.events)
  }
}
