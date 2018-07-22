import XCTest
@testable import BabylonHealthDemo

class SceneViewControllerExtensionTests: XCTestCase {

  func testDoesPostsSceneReturnCorrectVC() {
    XCTAssert(Scene.posts(PostsVM(navigationHandler: MockNavigationHandler(), dataManager: MockDataManager())).viewController() is PostsVC)
  }
  
  func testDoesEmbeddedPostsSceneReturnCorrectNavigationController() {
    let scene = Scene.postsEmbedded(PostsVM(navigationHandler: MockNavigationHandler(), dataManager: MockDataManager()))
    guard let nav = scene.viewController() as? UINavigationController else { XCTFail(); return }
    XCTAssert(nav.viewControllers.first is PostsVC)
  }
}
