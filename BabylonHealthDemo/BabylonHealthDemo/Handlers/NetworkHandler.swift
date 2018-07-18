import CocoaLumberjackSwift
import RealmSwift
import RxSwift
import RxRealm

public typealias ID = Int64

/// TODO: Always return Observable.changeset (Or .collection) and perform a URLSession fetch.
/// Feed the result of this fetch into the Realm DB and that will update the return observable.

protocol DataAccessor {
  var network: DataHandler { get set }
  var cached: DataHandler { get set }
}

protocol DataHandler {
  func users()
  
  func user(for id: ID)
  
  //func posts(between startingID: ID, and endingID: ID)
  func posts() -> Observable<[Post]>
  
  func comments(for postID: ID)
}

class DataAccessorImplementation: DataAccessor {
  var network: DataHandler
  var cached: DataHandler

  init(networkDataHandler: DataHandler, cachedDataHandler: DataHandler) {
    self.network = networkDataHandler
    self.cached = cachedDataHandler
  }
}

class NetworkDataHandler: DataHandler {
  func users() {
    DDLogInfo("Accessed network users")
  }
  
  func user(for id: ID) {
    DDLogInfo("Accessed network user with id \(id)")
  }
  
  func posts() -> Observable<[Post]> {
    
    DDLogInfo("Accessed network posts ")
    return Observable.empty()
  }
  
  func comments(for postID: ID) {
    DDLogInfo("Accessed network comment with id \(postID)")
  }
}

class CachedDataHandler: DataHandler {
  
  // TODO: Figure out if this should be optional or IUO
  // App would still function even if we could never access realm
  // but would provide an uncertain experience
  private let realm: Realm?
  
  required init() {
    realm = try? Realm()
    if realm == nil {
      DDLogError("Could not access realm instance.")
    }
  }
  
  func users() {
    DDLogInfo("Accessed cached users")
  }
  
  func user(for id: ID) {
    DDLogInfo("Accessed cached user with id \(id)")
  }
  
//  func posts(between startingID: ID, and endingID: ID) {
//    DDLogInfo("Accessed cached posts between \(startingID) and \(endingID)")
//  }
  
  // TODO: Check if this is still caching
  func posts() -> Observable<[Post]> {
    guard let realm = realm else { DDLogError("Could not access realm instance."); return Observable.empty() }
    let posts = realm.objects(Post.self)
    return Observable.collection(from: posts).map { $0.toArray() }
  }
  
  func comments(for postID: ID) {
    DDLogInfo("Accessed cached comment with id \(postID)")
  }
}
