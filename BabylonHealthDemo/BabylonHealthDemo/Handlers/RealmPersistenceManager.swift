import RxSwift
import RealmSwift
import CocoaLumberjackSwift

/// Manages the persistence of data using Realm
/// TODO: Make retrieving more generic, similar to how the APIService does so.
class RealmPersistenceManager {
  
  private func retrievePosts(filter: String?) -> Single<[Post]> {
    guard let realm = try? Realm() else { return Observable.error(RealmError.inaccessibleRealmInstance).asSingle() }
    var posts = realm.objects(PostPersistence.self)
    if let filter = filter {
      posts = posts.filter(filter)
    }
    
    return Observable.array(from: posts)
      // Map to non-persistent model
      .map(map(Post.init)) // (Observables of collections are a little clunky)
      .take(1)
      .asSingle()
  }
  
  private func retrieveUsers(filter: String?) -> Single<[User]> {
    guard let realm = try? Realm() else { return Observable.error(RealmError.inaccessibleRealmInstance).asSingle() }
    var users = realm.objects(UserPersistence.self)
    if let filter = filter {
      users = users.filter(filter)
    }
    
    return Observable.array(from: users)
      // Map to non-persistent model
      .map(map(User.init))
      .take(1)
      .asSingle()
  }
  
  private func retrieveComments(filter: String?) -> Single<[Comment]> {
    guard let realm = try? Realm() else { return Observable.error(RealmError.inaccessibleRealmInstance).asSingle() }
    var users = realm.objects(CommentPersistence.self)
    if let filter = filter {
      users = users.filter(filter)
    }
    
    return Observable.array(from: users)
      // Map to non-persistent model
      .map(map(Comment.init))
      .take(1)
      .asSingle()
  }
}

extension RealmPersistenceManager: PersistenceManager {
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
  
  // MARK: User Retrieval
  func retrieveUsers() -> Single<[User]> {
    return retrieveUsers(filter: nil)
  }
  func retrieveUser(id: Int64) -> Single<[User]> {
    let filter = "id == \(id)"
    return retrieveUsers(filter: filter)
  }
  
  // MARK: Comment Retrieval
  func retrieveComments() -> Single<[Comment]> {
    return retrieveComments(filter: nil)
  }
  func retrieveComment(id: Int64) -> Single<[Comment]> {
    let filter = "id == \(id)"
    return retrieveComments(filter: filter)
  }
  func retrieveComments(on postID: Int64) -> Single<[Comment]> {
    let filter = "postID == \(postID)"
    return retrieveComments(filter: filter)
  }
  
  // MARK: Saving to persistence
  // TODO: Make this into Observable so we can propagate errors properly
  func persist<Model: InternalModel>(persistentModels: [Model]) {
    guard let realm = try? Realm() else { DDLogError("Could not access realm database."); return }
    try? realm.write {
      persistentModels.forEach { persistentModel in
        // Get persistent type of class and initialise
        realm.add(persistentModel.persistentModel, update: .all)
      }
    }
  }
}
