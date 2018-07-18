import Foundation
import RealmSwift

@objcMembers class Comment: Object, Decodable {
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
}
