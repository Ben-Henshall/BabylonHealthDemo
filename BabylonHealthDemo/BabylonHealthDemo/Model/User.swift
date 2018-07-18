import Foundation
import RealmSwift

@objcMembers class User: Object, Decodable {
  dynamic var id: Int64 = 0
  dynamic var username = ""
  // Left other, unused properties out of the model due to time.
  // If I were to add them, I'd likely have to add a realm migration
  // Plus - if we're not using address of users, it would be best not to store it.
  // Accidentally leaking user details would _not_ be good
  
  override static func primaryKey() -> String? {
    return "id"
  }
}
