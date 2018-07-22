import RxSwift
@testable import BabylonHealthDemo

class MockDataManager: DataManagerType {
  private var postsObservable: Observable<[Post]>!
  private var usersObservable: Observable<[User]>!
  private var commentsObservable: Observable<[Comment]>!
  
  init(posts: Observable<[Post]>, users: Observable<[User]>, comments: Observable<[Comment]>) {
    postsObservable = posts
    usersObservable = users
    commentsObservable = comments
  }
  
  // Empty init for when we don't need a dataManager
  init() {
    postsObservable = Observable.empty()
    usersObservable = Observable.empty()
    commentsObservable = Observable.empty()
  }
  
  // MARK: - Posts
  func posts() -> Observable<[Post]> {
    return postsObservable
  }
  func posts(startingFrom startingID: Int64, limit: Int64) -> Observable<[Post]> {
    return postsObservable
  }
  func post(id: Int64) -> Observable<[Post]> {
    return postsObservable
  }
  
  // MARK: - Users
  func users() -> Observable<[User]> {
    return usersObservable
  }
  func user(id: Int64) -> Observable<[User]> {
    return usersObservable
  }
  
  // MARK: - Comments
  func comments() -> Observable<[Comment]> {
    return commentsObservable
  }
  func comment(id: Int64) -> Observable<[Comment]> {
    return commentsObservable
  }
  func comments(on postID: Int64) -> Observable<[Comment]> {
    return commentsObservable
  }
}
