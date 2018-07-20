import RxSwift

protocol DataManagerType {
  func posts() -> Observable<[Post]>
  func posts(startingFrom startingID: Int64, limit: Int64) -> Observable<[Post]>
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
    return fetch(persistant: persistanceManager.retrievePersistantPosts(), network: apiService.posts())
  }
  
  func posts(startingFrom startingID: Int64, limit: Int64) -> Observable<[Post]> {
    return fetch(persistant: persistanceManager.retrievePersistantPosts(), network: apiService.posts(startingFrom: startingID, limit: limit))
  }

  private func fetch<T: InternalModel>(persistant: Single<[T]>, network: Single<[T]>) -> Observable<[T]> {
    return Observable.create { [unowned self] observer in
      
      // Get persistant objects
      let persistanceSub = persistant
        .subscribe(onSuccess: { (persistantArray) in
          observer.onNext(persistantArray)
        })
      
      // TODO: errors for above
      
      // TODO: Combine these two streams
      
      // get posts from APIService
      let newObjects = network
        .asObservable()
        .share(replay: 1, scope: .forever)
        .asSingle()
      // TODO: Review above
      
      // TODO: add retry logic
      let networkSub = newObjects
        .subscribe(onSuccess: { newObjectsArray in
          observer.onNext(newObjectsArray)
        })
      // TODO: Errors for above
      
      let createPersistanceSub = newObjects
        .subscribe(onSuccess: { [unowned self] newObjectsArray in
          self.persistanceManager.persist(persistantModels: newObjectsArray)
          observer.onCompleted()
        })
      
      return Disposables.create {
        persistanceSub.dispose()
        networkSub.dispose()
        createPersistanceSub.dispose()
      }
      }.observeOn(SerialDispatchQueueScheduler(qos: .background))
  }
}
