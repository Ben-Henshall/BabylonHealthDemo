import RxSwift

/// Manager class that manages both the persistence of data and the pulling of new data through
/// different services
class DataManager {
  private let disposeBag = DisposeBag()
  
  private let apiService: NetworkService
  private let persistenceManager: PersistenceManager
  
  init(apiService: NetworkService, persistenceManager: PersistenceManager) {
    self.apiService = apiService
    self.persistenceManager = persistenceManager
  }
  
  private func fetch<Model: InternalModel>(persistent: Single<[Model]>, network: Single<[Model]>) -> Observable<[Model]> {
    return Observable.create { [unowned self] observer in
      
      // Get any persistent objects and emit them
      let persistenceSub = persistent
        // Due to Realm threading issues, this work can't easily be offloaded to a background thread.
        .subscribe(onSuccess: { (persistentArray) in
          observer.onNext(persistentArray)
        }, onError: { error in
          observer.onError(error)
        })

      // Get new objects from from the API, add them to persistence then emit them. 
      let networkSub = network
        .observeOn(SerialDispatchQueueScheduler(qos: .background))
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
    }
  }
}

extension DataManager: DataManagerType {
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
}
