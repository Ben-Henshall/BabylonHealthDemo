import RxSwift

protocol PersistenceManager {
  
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
  /// - Parameter id: The identifier of the User to retrieve
  /// - Returns: Single that emits the User object with the matching identifier
  func retrieveUser(id: Int64) -> Single<[User]>
  
  // MARK: Comment Retrieval
  
  /// Retrieves all comments from persistence
  ///
  /// - Returns: Single that emits all Post objects stored in persistence then completes
  func retrieveComments() -> Single<[Comment]>
  
  /// Retrieves a comment matching a given ID from persistence
  ///
  /// - Parameter id: The identifier of the comment to return
  /// - Returns:  Single that emits the Comment object with the matching identifier
  func retrieveComment(id: Int64) -> Single<[Comment]>
  
  /// Retrieves all comments on a given post from persistence
  ///
  /// - Parameter id: The identifier of the post to retrieve comments for
  /// - Returns: Single that emits all Comment objects with the matching postID
  func retrieveComments(on postID: Int64) -> Single<[Comment]>
  
  // MARK: Persistence
  
  /// Adds passed models to persistence
  ///
  /// - Parameter persistentModels: The models to add to persistence
  func persist<Model: InternalModel>(persistentModels: [Model])
}
