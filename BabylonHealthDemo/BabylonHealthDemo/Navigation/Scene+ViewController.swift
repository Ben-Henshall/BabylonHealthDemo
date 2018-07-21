import UIKit

extension Scene {
  
  /// Fetches a ViewController for the Scene. ViewController could be embedded in a NavigationController.
  /// Also sets up Rx bindings
  ///
  /// - Returns: The ViewController to represent the Scene
  public func viewController() -> UIViewController {
    switch self {
    case .posts(let viewModel):
      return PostsVC(viewModel: viewModel)
      
    case .postsEmbedded(let viewModel):
      return UINavigationController(rootViewController: PostsVC(viewModel: viewModel))
      
    case .postDetail(let viewModel):
      return PostDetailVC(viewModel: viewModel)
    }
  }
}
