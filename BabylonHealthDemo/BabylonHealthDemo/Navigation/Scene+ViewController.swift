import UIKit

extension Scene {
  
  public func viewController() -> UIViewController {
    switch self {
    case .posts(let viewModel):
      var vc = PostsVC()
      vc.bindViewModel(to: viewModel)
      return vc
    }
  }
}
