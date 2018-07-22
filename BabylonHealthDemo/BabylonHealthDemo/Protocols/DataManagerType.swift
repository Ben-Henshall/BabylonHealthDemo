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
