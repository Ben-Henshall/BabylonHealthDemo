import Foundation
import RealmSwift

@objcMembers class PostPersistance: Object {
  dynamic var id: Int64 = 0
  dynamic var userID: Int64 = 0 // Author
  dynamic var title = ""
  dynamic var body = ""

  override static func primaryKey() -> String? {
    return "id"
  }
  
  convenience init(post: Post) {
    self.init(id: post.id, userID: post.userID, title: post.title, body: post.body)
    
  }
  
  convenience init(id: Int64, userID: Int64, title: String, body: String) {
    self.init()
    self.id = id
    self.userID = userID
    self.title = title
    self.body = body
  }
  
}

struct Post: InternalModel {
  
  var id: Int64 = 0
  var userID: Int64 = 0 // Author
  var title = ""
  var body = ""
  
  func persistantModel() -> PostPersistance {
    return PostPersistance(post: self)
  }

  enum CodingKeys: String, CodingKey {
    case id
    case userID = "userId"
    case title
    case body
  }
  
  init(persistant: PostPersistance) {
    self.init(id: persistant.id, userID: persistant.userID, title: persistant.title, body: persistant.body)
  }
  
  init(id: Int64, userID: Int64, title: String, body: String) {
    self.id = id
    self.userID = userID
    self.title = title
    self.body = body
  }
}

protocol InternalModel: Decodable {
  associatedtype PersistantModelType: Object
  func persistantModel() -> PersistantModelType
}
