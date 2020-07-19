import Foundation
import RealmSwift

/// Internal model of a Post
struct Post: InternalModel {
  
  var id: Int64 = 0
  var userID: Int64 = 0 // Author
  var title = ""
  var body = ""
  
  enum CodingKeys: String, CodingKey {
    case id
    case userID = "userId"
    case title
    case body
  }
  
  // MARK: - InternalModel requirements
  var persistentModel: PostPersistence {
    return PostPersistence(post: self)
  }
  
  init(persistentModel: PostPersistence) {
    self.init(id: persistentModel.id, userID: persistentModel.userID, title: persistentModel.title, body: persistentModel.body)
  }
  
  init(id: Int64, userID: Int64, title: String, body: String) {
    self.id = id
    self.userID = userID
    self.title = title
    self.body = body
  }
}

extension Post: Equatable { }

/// Persistence model used to store in Realm
@objcMembers class PostPersistence: Object {
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
