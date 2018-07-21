import RxSwift

protocol DataManagerType {
  
  // MARK: Post Retrieval

  /// Retrieves all posts
  ///
  /// - Returns: Observable that emits persistent posts, then fresh posts, then completes
  func posts() -> Observable<[Post]>
  
  /// Retrieves X posts starting from a given ID
  ///
  /// - Parameters:
  ///   - startingID: The ID of the first post
  ///   - limit: The number of posts to return
  /// - Returns: Observable that emits persistent posts, then fresh posts, then completes
  func posts(startingFrom startingID: Int64, limit: Int64) -> Observable<[Post]>
  
  /// Retrieves a post matching a given ID
  ///
  /// - Parameter id: The identifier of the post to return
  /// - Returns: Observable that emits the persistent post, then the fresh post, then completes
  func post(id: Int64) -> Observable<[Post]>
  
  // MARK: User Retrieval

  /// Retrieves all users
  ///
  /// - Returns: Observable that emits persistent users, then fresh users, then completes
  func users() -> Observable<[User]>

  /// Retrieves a user matching a given ID
  ///
  /// - Parameter id: The identifier of the user to return
  /// - Returns: Observable that emits the persistent user, then the fresh user, then completes
  func user(id: Int64) -> Observable<[User]>
  
  // MARK: Comment Retrieval
  
  /// Retrieves all comments
  ///
  /// - Returns: Observable that emits persistent comments, then fresh comments, then completes
  func comments() -> Observable<[Comment]>
  
  /// Retrieves a comment matching a given ID
  ///
  /// - Parameter id: The identifier of the comment to return
  /// - Returns: Observable that emits the persistent comment, then the fresh comment, then completes
  func comment(id: Int64) -> Observable<[Comment]>
  
  /// Retrieves all comments on a given post
  ///
  /// - Parameter id: The identifier of the post to retrieve comments for
  /// - Returns: Observable that emits the persistent comments on a post, then the fresh comments, then completes
  func comments(on postID: Int64) -> Observable<[Comment]>
}

/// Manager class that manages both the persistence of data and the pulling of new data through
/// different services
class DataManager: DataManagerType {
  private let disposeBag = DisposeBag()
  
  private let apiService: APIServiceType
  private let persistenceManager: PersistenceManagerType
  
  init(apiService: APIServiceType, persistenceManager: PersistenceManagerType) {
    self.apiService = apiService
    self.persistenceManager = persistenceManager
  }
  
  // MARK: Post retrieval methods
  func posts() -> Observable<[Post]> {
    return fetch(persistent: persistenceManager.retrievePosts(), network: apiService.posts())
  }
  func posts(startingFrom startingID: Int64, limit: Int64) -> Observable<[Post]> {
    return fetch(persistent: persistenceManager.retrievePosts(startingFrom: startingID, limit: limit), network: apiService.posts(startingFrom: startingID, limit: limit))
  }
  func post(id: Int64) -> Observable<[Post]> {
    return fetch(persistent: persistenceManager.retrievePost(id: id), network: apiService.post(id: id))
  }
  
  // MARK: User retrieval methods
  func users() -> Observable<[User]> {
    return fetch(persistent: persistenceManager.retrieveUsers(), network: apiService.users())
  }
  func user(id: Int64) -> Observable<[User]> {
    return fetch(persistent: persistenceManager.retrieveUser(id: id), network: apiService.user(id: id))
  }

  // MARK: Comment retrieval methods
  func comments() -> Observable<[Comment]> {
    return fetch(persistent: persistenceManager.retrieveComments(), network: apiService.comments())
  }
  func comment(id: Int64) -> Observable<[Comment]> {
    return fetch(persistent: persistenceManager.retrieveComment(id: id), network: apiService.comment(id: id))
  }
  func comments(on postID: Int64) -> Observable<[Comment]> {
    return fetch(persistent: persistenceManager.retrieveComments(on: postID), network: apiService.comments(on: postID))
  }
  
  private func fetch<T: InternalModel>(persistent: Single<[T]>, network: Single<[T]>) -> Observable<[T]> {
    return Observable.create { [unowned self] observer in
      
      // Get any persistent objects and emit them
      let persistenceSub = persistent
        .subscribe(onSuccess: { (persistentArray) in
          observer.onNext(persistentArray)
        }, onError: { error in
          observer.onError(error)
        })

      // Get new objects from from the API, add them to persistence then emit them. 
      let networkSub = network
        // TODO: FlatMap into persist so we can maintain the errors
        .do(onSuccess: { newObjectsArray in
          self.persistenceManager.persist(persistentModels: newObjectsArray)
        })
        .subscribe(onSuccess: { newObjectsArray in
          observer.onNext(newObjectsArray)
          observer.onCompleted()
        }, onError: { error in
          observer.onError(error)
        })

      return Disposables.create {
        persistenceSub.dispose()
        networkSub.dispose()
      }
    }.debug("fetch", trimOutput: true)
      .observeOn(SerialDispatchQueueScheduler(qos: .background))
  }
}
