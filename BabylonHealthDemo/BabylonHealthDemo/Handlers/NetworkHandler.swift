import CocoaLumberjackSwift

public typealias ID = Int64

protocol DataAccessor {
  var network: DataHandler { get set }
  var cached: DataHandler { get set }
}

protocol DataHandler {
  func users()
  
  func user(for id: ID)
  
  //func posts(between startingID: ID, and endingID: ID)
  func posts()
  
  func comments(for postID: ID)
}

class DataAccessorImplementation: DataAccessor {
  var network: DataHandler
  var cached: DataHandler

  init(networkDataHandler: DataHandler, cachedDataHandler: DataHandler) {
    self.network = networkDataHandler
    self.cached = cachedDataHandler
  }
}

class NetworkDataHandler: DataHandler {
  func users() {
    DDLogInfo("Accessed network users")
  }
  
  func user(for id: ID) {
    DDLogInfo("Accessed network user with id \(id)")
  }
  
  func posts() {
    DDLogInfo("Accessed network posts ")
  }
  
  func comments(for postID: ID) {
    DDLogInfo("Accessed network comment with id \(postID)")
  }
}

class CachedDataHandler: DataHandler {
  func users() {
    DDLogInfo("Accessed cached users")
  }
  
  func user(for id: ID) {
    DDLogInfo("Accessed cached user with id \(id)")
  }
  
//  func posts(between startingID: ID, and endingID: ID) {
//    DDLogInfo("Accessed cached posts between \(startingID) and \(endingID)")
//  }
  
  func posts() {
    DDLogInfo("Accessed cached posts between")
  }
  
  func comments(for postID: ID) {
    DDLogInfo("Accessed cached comment with id \(postID)")
  }
}
