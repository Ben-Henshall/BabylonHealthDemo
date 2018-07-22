import RxSwift

protocol NetworkService {
  
  // MARK: Post fetching
  
  /// Fetches all posts from the API
  ///
  /// - Returns: A Single that emits an array of posts then completes
  func posts() -> Single<[Post]>
  
  /// Retrieves X Post objects starting from a given ID
  ///
  /// - Parameters:
  ///   - startingID: The ID of the first post
  ///   - limit: The number of posts to return
  /// - Returns: Single that emits posts pulled from an API
  func posts(startingFrom startingID: Int64, limit: Int64) -> Single<[Post]>
  
  /// Fetches a specific post object when given an ID
  ///
  /// - Parameter id: The identifier of the post to fetch
  /// - Returns: A Single emitting an array of size 1, containing the requested post
  func post(id: Int64) -> Single<[Post]>
  
  // MARK: User Fetching
  
  /// Fetches all users from the API
  ///
  /// - Returns: A Single that emits an array of users then completes
  func users() -> Single<[User]>
  
  /// Fetches a specific user object when given an ID
  ///
  /// - Parameter id: The identifier of the user to fetch
  /// - Returns: A Single emitting an array of size 1, containing the requested user
  func user(id: Int64) -> Single<[User]>
  
  // MARK: Comment Fetching
  
  /// Fetches all comments from the API
  ///
  /// - Returns: A Single that emits an array of comments then completes
  func comments() -> Single<[Comment]>
  
  /// Fetches a specific Comment object when given an ID
  ///
  /// - Parameter id: The identifier of the Comment to fetch
  /// - Returns: A Single emitting an array of size 1, containing the requested Comment
  func comment(id: Int64) -> Single<[Comment]>
  
  /// Fetches all Comments with a matching postID form the API
  ///
  /// - Parameter postID: The identifier of the post to fetch comments for
  /// - Returns: A Single emitting an array of all comments with a matching postID
  func comments(on postID: Int64) -> Single<[Comment]>
}
