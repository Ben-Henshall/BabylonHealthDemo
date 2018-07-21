import CocoaLumberjackSwift
import RealmSwift
import RxSwift
import RxRealm

protocol APIServiceType {
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
