import Foundation
import RealmSwift

@objcMembers class Post: Object, Decodable {
  dynamic var id: Int64 = 0
  dynamic var userID: Int64 = 0 // Author
  dynamic var title = ""
  dynamic var body = ""

  override static func primaryKey() -> String? {
    return "id"
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case userID = "userId"
    case title
    case body
  }
}
