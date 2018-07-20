import RxSwift
import RealmSwift
import CocoaLumberjackSwift

protocol PersistanceManagerType {
  func retrievePersistantPosts() -> Single<[Post]>
  func persist<T: InternalModel>(persistantModels: [T])
}

class PersistanceManager: PersistanceManagerType {
  func retrievePersistantPosts() -> Single<[Post]> {
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
  
  // TODO: make protocol to specify T param
  func persist<T>(persistantModels: [T]) where T : InternalModel {
    guard let realm = try? Realm() else { DDLogError("Could not access realm database."); return }
    
    try? realm.write {
      persistantModels.forEach { persistantModel in
        // Get persistant type of class and initialise
        realm.add(persistantModel.persistantModel(), update: true)
      }
    }
  }
}
