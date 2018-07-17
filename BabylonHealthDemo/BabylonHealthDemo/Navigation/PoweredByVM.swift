import UIKit

/// I decided to remove this functionality due to the added complexity.
/// The shared intialisation only saves an average of 3/4 lines per VC,
/// but adds complexity due to fragmenting initialisation into another file,
/// rather than in the VC itself.

///// Shared initialisation between ViewControllers.
//protocol PoweredByVM where Self: UIViewController {
//  associatedtype ViewModelType
//
//  var viewModel: ViewModelType! { get set }
//
//  init(viewModel: ViewModelType)
//}
//
///// Shared implementation of the shared initialisation that simply sets the ViewModel of the ViewController.
//extension PoweredByVM where Self: UIViewController {
//  init(viewModel: ViewModelType) {
//    self.init(nibName: nil, bundle: nil)
//    self.viewModel = viewModel
//  }
//}
