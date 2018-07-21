import UIKit
import CocoaLumberjackSwift
import RealmSwift
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var dataManager: DataManager!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setup()
    
    //setupRealmModel()
    setupDataAccessor()
    startApp()
    
    return true
  }
  
  private func setupDataAccessor() {
    let apiService = APIService()
    let persistenceManager = RealmPersistenceManager()
    dataManager = DataManager(apiService: apiService, persistenceManager: persistenceManager)
  }
  
  private func startApp() {
    let sceneCoordinator = SceneCoordinator(window: window!)
    
    let startingViewModel = PostsVM(navigationHandler: sceneCoordinator, dataManager: dataManager)
    let viewController = PostsVC(viewModel: startingViewModel)
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.delegate = sceneCoordinator

    sceneCoordinator.transition(to: .postsEmbedded(startingViewModel), type: .root, animated: false)
  }
  
  private func setup() {
    setupLogging()
    setupWindow()
  }

  private func setupLogging() {
    DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
    DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs

    let fileLogger: DDFileLogger = DDFileLogger() // File Logger
    fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7
    DDLog.add(fileLogger)
  }
  
  private func setupWindow() {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
  }
  
  // TODO: Delete when networking is in
  private func setupRealmModel() {
    let user1 = User()
    user1.id = 1
    user1.username = "user1"
    
    let user2 = User()
    user2.id = 2
    user2.username = "user2"
    
    let user3 = User()
    user3.id = 3
    user3.username = "user3"
    
    let post1 = PostPersistence()
    post1.id = 1
    post1.body = "post-body-1"
    post1.title = "post-title-1"
    post1.userID = 1
    
    let post2 = PostPersistence()
    post2.id = 2
    post2.body = "post-body-2"
    post2.title = "post-title-2"
    post2.userID = 3
    
    let comment1 = Comment()
    comment1.id = 1
    comment1.body = "post1-comment-1-body"
    comment1.email = "post1-comment-1-email"
    comment1.name = "post1-comment-1-name"
    comment1.postID = 1
    
    let comment2 = Comment()
    comment2.id = 2
    comment2.body = "post1-comment-2-body"
    comment2.email = "post1-comment-2-email"
    comment2.name = "post1-comment-2-name"
    comment2.postID = 1
    
    let comment3 = Comment()
    comment3.id = 3
    comment3.body = "post2-comment-3-body"
    comment3.email = "post2-comment-3-email"
    comment3.name = "post2-comment-3-name"
    comment3.postID = 2
    
    if let realm = try? Realm() {
      do {
        try realm.write {
          realm.add(post1)
          realm.add(post2)
          
          realm.add(user1)
          realm.add(user2)
          realm.add(user3)
          
          realm.add(comment1)
          realm.add(comment2)
          realm.add(comment3)
        }
      } catch {
        
      }
    }
  }
  
  

}
