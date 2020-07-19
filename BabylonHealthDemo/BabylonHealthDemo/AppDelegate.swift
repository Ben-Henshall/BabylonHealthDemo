import UIKit
import CocoaLumberjackSwift
import RealmSwift
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var dataManager: DataManager!
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    setup()
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
    DDLog.add(DDOSLogger.sharedInstance) // ASL = Apple System Logs

    let fileLogger: DDFileLogger = DDFileLogger() // File Logger
    fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7
    DDLog.add(fileLogger)
  }
  
  private func setupWindow() {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.makeKeyAndVisible()
  }
}
