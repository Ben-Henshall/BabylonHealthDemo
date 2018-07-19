import CocoaLumberjackSwift
import RealmSwift
import RxSwift
import RxRealm

public typealias ID = Int64

/// TODO: Always return Observable.changeset (Or .collection) and perform a URLSession fetch.
/// Feed the result of this fetch into the Realm DB and that will update the return observable.

protocol DataManagerType {
  func posts() -> Observable<[Post]>
}

protocol APIServiceType {
  func posts() -> Single<[Post]>
}

protocol PersistanceManagerType {
  func posts() -> Single<[Post]>
  func persistPosts(posts: [Post])
}

class DataManager: DataManagerType {
  private let disposeBag = DisposeBag()
  private let apiService: APIServiceType
  private let persistanceManager: PersistanceManagerType
  
  init(apiService: APIServiceType, persistanceManager: PersistanceManagerType) {
    self.apiService = apiService
    self.persistanceManager = persistanceManager
  }
  
  func posts() -> Observable<[Post]> {
    return Observable.create { [unowned self] observer in
      
      // Get persistant objects
      let persistanceSub = self.persistanceManager.posts()
        .debug("Posts persistance", trimOutput: true)
        .subscribe(onSuccess: { postsArray in
          observer.onNext(postsArray)
        })
      
      // TODO: errors for above

      // TODO: Combine these two streams
      
      // get posts from APIService
      let newPosts = self.apiService.posts()
      
      // TODO: add retry logic
      let newPostsSub = newPosts
        .subscribe(onSuccess: { postsArray in
          observer.onNext(postsArray)
        })
      // TODO: Errors for above
      
      let createPersistanceSub = newPosts
        .subscribe(onSuccess: { [unowned self] postsArray in
          self.persistanceManager.persistPosts(posts: postsArray)
          observer.onCompleted()
        })
      
      return Disposables.create {
        persistanceSub.dispose()
        newPostsSub.dispose()
      }
    }.observeOn(SerialDispatchQueueScheduler(qos: .background))
      .debug("PostsDataManager", trimOutput: true)

  }
}

class PersistanceManager: PersistanceManagerType {
  func posts() -> Single<[Post]> {
    // TODO: Return proper error below
    guard let realm = try? Realm() else { return Observable.empty().asSingle() }
    let posts = realm.objects(PostPersistance.self)
    return Observable.collection(from: posts)
      .map { $0.toArray() }
      // Map to non-persistant model
      .map { return $0.map { Post(persistant: $0) } }
      .take(1)
      .asSingle()
  }
  
  // TODO: make generic
  func persistPosts(posts: [Post]) {
    guard let realm = try? Realm() else { DDLogError("Could not access realm database."); return }
    
    try? realm.write {
      posts.forEach { post in
        let persistPost = PostPersistance(post: post)
        realm.add(persistPost, update: true)
      }
    }
  }
}

class APIService: APIServiceType {
  
  private let PostsEndpoint: URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!

  func posts() -> Single<[Post]> {
    return Observable.just(PostsEndpoint)
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
      .map { URLRequest(url: $0) }
      .flatMap { URLSession.shared.rx.response(request: $0) }
      .map { response, data -> [Post] in
        return try JSONDecoder().decode([Post].self, from: data)
      }
      .take(1)
      .debug("PostsPull", trimOutput: true)
      .asSingle()
  }
}

//protocol DataHandler {
//  func users()
//
//  func user(for id: ID)
//
//  //func posts(between startingID: ID, and endingID: ID)
//  func posts() -> Observable<[Post]>
//
//  func comments(for postID: ID)
//}

//class DataAccessorImplementation: DataAccessor {
//  var network: DataHandler
//  var cached: DataHandler
//
//  init(networkDataHandler: DataHandler, cachedDataHandler: DataHandler) {
//    self.network = networkDataHandler
//    self.cached = cachedDataHandler
//  }
//}
//
//class NetworkDataHandler: DataHandler {
//  func users() {
//    DDLogInfo("Accessed network users")
//  }
//  
//  func user(for id: ID) {
//    DDLogInfo("Accessed network user with id \(id)")
//  }
//  
//  func posts() -> Observable<[Post]> {
//    
//    DDLogInfo("Accessed network posts ")
//    return Observable.empty()
//  }
//  
//  func comments(for postID: ID) {
//    DDLogInfo("Accessed network comment with id \(postID)")
//  }
//}
//
//class CachedDataHandler: DataHandler {
//  
//  private let disposeBag: DisposeBag = DisposeBag()
//  // TODO: Figure out if this should be optional or IUO
//  // App would still function even if we could never access realm
//  // but would provide an uncertain experience
//  private var realm: Realm!
//  
//  required init() {
//    // swiftlint:disable force_try
//    DispatchQueue(label: "background", qos: .background).async { [unowned self] in
//      self.realm = try! Realm()
//    }
//  }
//  
//  func users() {
//    DDLogInfo("Accessed cached users")
//  }
//  
//  func user(for id: ID) {
//    DDLogInfo("Accessed cached user with id \(id)")
//  }
//  
////  func posts(between startingID: ID, and endingID: ID) {
////    DDLogInfo("Accessed cached posts between \(startingID) and \(endingID)")
////  }
//  
//  private let PostsEndpoint: URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
//  
//  // TODO: Check if this is still caching
//  func posts() -> Observable<[Post]> {
//    //guard let realm = realm else { DDLogError("Could not access realm instance."); return Observable.empty() }
//    
//    Observable.just(PostsEndpoint)
//      .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
//      .map { URLRequest(url: $0) }
//      .flatMap { URLSession.shared.rx.response(request: $0) }
//      .map { response, data -> [Post] in
//        return try JSONDecoder().decode([Post].self, from: data)
//      }
//      .take(1)
//      .debug("PostsPull", trimOutput: true)
//      //.observeOn(SerialDispatchQueueScheduler(qos: .background))
//      .subscribe(onNext: { posts in
//        guard let realm = try? Realm() else { DDLogError("Could not dereference realm"); return }
//        try! realm.write {
//          realm.add(posts)
//        }
//        let somet = posts
//      })
//      // TODO: use subscribe as a closure and instantiate realm in there
//      // Or, use lazy instantiation!
//      
//      
////      .subscribe(onNext: { [unowned self] posts in
////        try! self.realm.write {
////          realm.add(posts[0])
////        }
////        let somet = posts
////      })
//      .disposed(by: disposeBag)
//      //.observeOn(Scheduler)
//    
//    guard let realm = try? Realm() else { DDLogError("Could not dereference realm"); return Observable.empty() }
//
//    let posts = realm.objects(Post.self)
//    
//    return Observable.collection(from: posts).map { $0.toArray() }
//  }
//  
//  func comments(for postID: ID) {
//    DDLogInfo("Accessed cached comment with id \(postID)")
//  }
//}
