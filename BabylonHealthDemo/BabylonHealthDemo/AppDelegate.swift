import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setup()
    
    let viewController = UIViewController()
    let navigationController = UINavigationController(rootViewController: viewController)
    window?.rootViewController = navigationController
    
    let sceneCoordinator = SceneCoordinator(window: window!)
    navigationController.delegate = sceneCoordinator
    
    let startingViewModel = PostsVM(navigationHandler: sceneCoordinator)
    sceneCoordinator.transition(to: .postsEmbedded(startingViewModel), type: .root, animated: false)
    
    return true
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

}
