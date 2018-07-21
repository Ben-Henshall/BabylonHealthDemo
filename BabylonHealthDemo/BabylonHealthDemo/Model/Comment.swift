import Foundation
import RealmSwift

struct Comment: Decodable, InternalModel {
  var id: Int64 = 0
  var name = ""
  var email = ""
  var body = ""
  var postID: Int64 = 0
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case email
    case body
    case postID = "postId"
  }
  
  // MARK: InternalModel requirements
  var persistentModel: CommentPersistence {
    return CommentPersistence(comment: self)
  }
  
  init(persistentModel: CommentPersistence) {
    self.init(id: persistentModel.id, name: persistentModel.name, email: persistentModel.email, body: persistentModel.body, postID: persistentModel.postID)
  }
  
  init(id: Int64, name: String, email: String, body: String, postID: Int64) {
    self.id = id
    self.name = name
    self.email = email
    self.body = body
    self.postID = postID
  }
}

@objcMembers class CommentPersistence: Object {
  dynamic var id: Int64 = 0
  dynamic var name = ""
  dynamic var email = ""
  dynamic var body = ""
  dynamic var postID: Int64 = 0
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case email
    case body
    case postID = "postId"
  }
  
  convenience init(comment: Comment) {
    self.init(id: comment.id, name: comment.name, email: comment.email, body: comment.body, postID: comment.postID)
  }
  
  convenience init(id: Int64, name: String, email: String, body: String, postID: Int64) {
    self.init()
    self.id = id
    self.name = name
    self.email = email
    self.body = body
    self.postID = postID
  }
}
