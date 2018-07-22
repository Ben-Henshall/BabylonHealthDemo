import RealmSwift

/// Protocol to identify the internal model structs that we use for passing around the app
/// Used to convert to a persistent object when adding items to persistence.
protocol InternalModel: Decodable {
  associatedtype PersistentModelType: Object
  
  /// Returns a persistent equivalent of the model to save to persistence
  var persistentModel: PersistentModelType { get }
  
  /// Initialises an InternalModel object with a Persistent version of that model
  ///
  /// - Parameter persistentModel: The persistent model version of the InternalModel
  init(persistentModel: PersistentModelType)
}
