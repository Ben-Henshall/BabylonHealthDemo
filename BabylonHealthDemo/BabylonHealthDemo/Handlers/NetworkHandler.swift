import CocoaLumberjackSwift
import RealmSwift
import RxSwift
import RxRealm

public class APIService {
  
  private let urlSession: URLSession
  
  public init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
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
  
  // Generic method to request, parse and emit data from a given endpoint
  // TODO: Add retry mechanism using timer to retry every x seconds up to Y number of times
  private func request<Model: Decodable>(endpoint: Endpoint, parameters: [Parameters: String] = [:]) -> Single<Model> {
    return Observable.just(endpoint)
      .map(\.url)
      .map { url -> URL in
        var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        comps.queryItems = parameters.map { URLQueryItem(name: $0.key.rawValue, value: $0.value) }
        return comps.url!
      }
      .map { URLRequest.init(url: $0) }
      .flatMap(urlSession.rx.response(request:))
      // TODO: check response for error
      .map { _, data in
        try JSONDecoder().decode(Model.self, from: data)
      }
      .take(1)
      .asSingle()
  }
}

extension APIService: NetworkService {
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
}
