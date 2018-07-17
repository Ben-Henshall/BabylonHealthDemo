import UIKit
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setup()
    startApp()
    
    return true
  }

  private func startApp() {
    let sceneCoordinator = SceneCoordinator(window: window!)
    
    let startingViewModel = PostsVM(navigationHandler: sceneCoordinator)
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

}
