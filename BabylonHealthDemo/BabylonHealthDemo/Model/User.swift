import Foundation
import RealmSwift

@objcMembers class User: Object {
  dynamic var id: Int64 = 0
  dynamic var username = ""
  // Left other, unused properties out of the model due to time.
  // If I were to add them, I'd likely have to add a realm migration
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
