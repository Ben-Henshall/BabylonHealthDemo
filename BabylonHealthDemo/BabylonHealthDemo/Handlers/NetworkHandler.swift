import CocoaLumberjackSwift
import RealmSwift
import RxSwift
import RxRealm

protocol APIServiceType {
  func posts() -> Single<[Post]>
  func posts(startingFrom startingID: Int64, limit: Int64) -> Single<[Post]>
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
  
  // TODO: Try and make parameters type safe
  fileprivate enum Parameters: String {
    case startID = "_start" // e.g. "10"
    case limit = "_limit" // e.g. "5"
    case id = "id"
  }
  
  func posts() -> Single<[Post]> {
    return request(endpoint: .posts)
  }
  
  func posts(startingFrom startingID: Int64, limit: Int64) -> Single<[Post]> {
    return request(endpoint: .posts, parameters: [.startID: "\(startingID)", .limit: "\(limit)"])
  }
  
  func post(id: Int64) -> Single<[Post]> {
    return request(endpoint: .posts, parameters: [.id: "\(id)"])
  }
  
  private func request<T: Decodable>(endpoint: Endpoint, parameters: [Parameters: String] = [:]) -> Single<T> {
    return Observable.just(endpoint)
      .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
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
