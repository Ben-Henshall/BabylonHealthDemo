import CocoaLumberjackSwift
import RealmSwift
import RxSwift
import RxRealm

protocol APIServiceType {
  
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

class APIService: APIServiceType {
  
  fileprivate enum Endpoint: String {
    case posts
    case users
    case comments
    
    private var baseURL: String { return "https://jsonplaceholder.typicode.com/" }
    var url: URL {
      return URL(string: "\(baseURL)\(rawValue)")!
    }
  }
  
  // TODO: Improve by making inputs type-safe (e.g. converting Ints to to strings)
  fileprivate enum Parameters: String {
    case startID = "_start"
    case limit = "_limit"
    case id = "id"
    case postID = "postId"
    case userID = "userId"
  }
  
  // MARK: Post Fetching
  func posts() -> Single<[Post]> {
    return request(endpoint: .posts)
  }
  func posts(startingFrom startingID: Int64, limit: Int64) -> Single<[Post]> {
    return request(endpoint: .posts, parameters: [.startID: "\(startingID)", .limit: "\(limit)"])
  }
  func post(id: Int64) -> Single<[Post]> {
    return request(endpoint: .posts, parameters: [.id: "\(id)"])
  }
  
  // MARK: User Fetching
  func users() -> Single<[User]> {
    return request(endpoint: .users)
  }
  func user(id: Int64) -> Single<[User]> {
    return request(endpoint: .users, parameters: [.id: "\(id)"])
  }
  
  // MARK: Comment Fetching
  func comments() -> Single<[Comment]> {
    return request(endpoint: .comments)
  }
  func comment(id: Int64) -> Single<[Comment]> {
    return request(endpoint: .comments, parameters: [.id: "\(id)"])
  }
  func comments(on postID: Int64) -> Single<[Comment]> {
    return request(endpoint: .comments, parameters: [.postID: "\(postID)"])
  }
  
  // Generic method to request, parse and emit data from a given endpoint
  private func request<T: Decodable>(endpoint: Endpoint, parameters: [Parameters: String] = [:]) -> Single<T> {
    return Observable.just(endpoint)
      .map { $0.url }
      .map { url -> URLComponents in
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        comps.queryItems = parameters.map { URLQueryItem(name: $0.key.rawValue, value: $0.value) }
        return comps
      }
      .map { $0.url! }
      .map { URLRequest(url: $0) }
      .flatMap { URLSession.shared.rx.response(request: $0) }
      // TODO: check response for error
      .map { response, data in
        return try JSONDecoder().decode(T.self, from: data)
      }
      .take(1)
      .asSingle()
  }
}
