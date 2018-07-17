import XCTest
@testable import BabylonHealthDemo

class ActualViewControllerTests: XCTestCase {

  func testDoesReturnSelfIfNotNavigationController() {
    let viewController = UIViewController()
    XCTAssertEqual(viewController, viewController.actualViewController)
  }
  
  func testDoesReturnFirstViewControllerIfGivenNavigationController() {
    let viewController = UIViewController()
    let navigationController = UINavigationController(rootViewController: viewController)
    XCTAssertEqual(viewController, navigationController.actualViewController)
  }
}
