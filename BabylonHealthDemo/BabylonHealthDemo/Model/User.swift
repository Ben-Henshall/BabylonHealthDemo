import Foundation
import RealmSwift

struct User: InternalModel {
  var id: Int64 = 0
  var username: String = ""
  
  // MARK: InternalModel requirements
  var persistentModel: UserPersistence {
    return UserPersistence(user: self)
  }
  
  init(persistentModel: UserPersistence) {
    self.init(id: persistentModel.id, username: persistentModel.username)
  }
  
  init(id: Int64, username: String) {
    self.id = id
    self.username = username
  }
}

@objcMembers class UserPersistence: Object {
  dynamic var id: Int64 = 0
  dynamic var username = ""
  // I Left other unused properties out of the model due to time.
  // If I were to add them, I'd likely have to add a realm migration
  // Plus - if we're not using address of users, it would be best not to store it.
  // Accidentally leaking user details would _not_ be good
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  convenience init(user: User) {
    self.init(id: user.id, username: user.username)
  }
  
  convenience init(id: Int64, username: String) {
    self.init()
    self.id = id
    self.username = username
  }
}
