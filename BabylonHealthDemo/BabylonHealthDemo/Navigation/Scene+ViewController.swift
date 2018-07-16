import UIKit

extension Scene {
  
  public func viewController() -> UIViewController {
    switch self {
    case .posts(let viewModel):
      var vc = PostsVC()
      vc.bindViewModel(to: viewModel)
      return vc
      
    case .postsEmbedded(let viewModel):
      var vc = PostsVC()
      vc.bindViewModel(to: viewModel)
      let navController = UINavigationController(rootViewController: vc)
      return navController
    }
  }
}
