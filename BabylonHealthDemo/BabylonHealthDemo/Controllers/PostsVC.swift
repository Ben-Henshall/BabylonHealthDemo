import UIKit
import RealmSwift
import CocoaLumberjackSwift

class PostsVC: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let testModel = TestModel()
    DDLogInfo(testModel.test)
  }
}

class TestModel: Object {
  // MARK: - Properties
  @objc dynamic var id: Int = 0
  @objc dynamic var test = "test text"
  
  // MARK: - Meta
  override static func primaryKey() -> String? {
    return "id"
  }
}
