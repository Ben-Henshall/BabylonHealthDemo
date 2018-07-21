import RxSwift
import RealmSwift
import CocoaLumberjackSwift

protocol PersistenceManagerType {
  
  // MARK: Post retrieval
  
  /// Retrieves all Post objects from persistence
  ///
  /// - Returns: Single that emits all Post objects stored in persistence then completes
  func retrievePosts() -> Single<[Post]>
  
  /// Retrieves X Post objects starting from a given ID
  ///
  /// - Parameters:
  ///   - startingID: ID of the first Post to return
  ///   - limit: The number of Posts to return
  /// - Returns: Single that emits X Post objects stored in persistence then completes
  func retrievePosts(startingFrom startingID: Int64, limit: Int64) -> Single<[Post]>
  
  /// Retrieves a specific Post object from persistence
  ///
  /// - Parameter id: The identifier of the Post to retrieve
  /// - Returns: Single that emits the Post object with the matching identifier
  func retrievePost(id: Int64) -> Single<[Post]>
  
  // MARK: User Retrieval
  
  /// Retrieves all User objects from persistence
  ///
  /// - Returns: Single that emits all User objects stored in persistence then completes
  func retrieveUsers() -> Single<[User]>

  /// Retrieves a specific User object from persistence
  ///
  /// - Parameter id: The identifier of the Post to retrieve
  /// - Returns: Single that emits the User object with the matching identifier
  func retrieveUser(id: Int64) -> Single<[User]>
  
  // MARK: Persistence
  
  /// Adds passed models to persistence
  ///
  /// - Parameter persistentModels: The models to add to persistence
  func persist<T: InternalModel>(persistentModels: [T])
}

/// Manages the persistence of data using Realm
/// TODO: Make retrieving more generic, similar to how the APIService does so.
class RealmPersistenceManager: PersistenceManagerType {
  
  // MARK: Post Retrieval
  func retrievePosts() -> Single<[Post]> {
    return retrievePosts(filter: nil)
  }
  
  func retrievePosts(startingFrom startingID: Int64, limit: Int64) -> Single<[Post]> {
    let maxID = startingID + limit
    let filter = "id > \(startingID) AND id <= \(maxID)"
    return retrievePosts(filter: filter)
  }
  
  func retrievePost(id: Int64) -> Single<[Post]> {
    let filter = "id == \(id)"
    return retrievePosts(filter: filter)
  }
  
  private func retrievePosts(filter: String?) -> Single<[Post]> {
    guard let realm = try? Realm() else { return Observable.error(RealmError.inaccessibleRealmInstance).asSingle() }
    var posts = realm.objects(PostPersistence.self)
    if let filter = filter {
      posts = posts.filter(filter)
    }

    return Observable.array(from: posts)
      // Map to non-persistent model
      .map { return $0.map { Post(persistentModel: $0) } }
      .take(1)
      .asSingle()
  }
  
  // MARK: User Retrieval
  func retrieveUsers() -> Single<[User]> {
    return retrieveUsers(filter: nil)
  }

  func retrieveUser(id: Int64) -> Single<[User]> {
    let filter = "id == \(id)"
    return retrieveUsers(filter: filter)
  }
  
  private func retrieveUsers(filter: String?) -> Single<[User]> {
    guard let realm = try? Realm() else { return Observable.error(RealmError.inaccessibleRealmInstance).asSingle() }
    var users = realm.objects(UserPersistence.self)
    if let filter = filter {
      users = users.filter(filter)
    }
    
    return Observable.array(from: users)
      // Map to non-persistent model
      .map { return $0.map { User(persistentModel: $0) } }
      .take(1)
      .asSingle()
  }
  
  // MARK: Saving to persistence
  // TODO: Make this into Observable so we can propagate errors properly
  func persist<T: InternalModel>(persistentModels: [T]) {
    guard let realm = try? Realm() else { DDLogError("Could not access realm database."); return }
    try? realm.write {
      persistentModels.forEach { persistentModel in
        // Get persistent type of class and initialise
        realm.add(persistentModel.persistentModel, update: true)
      }
    }
  }
}
