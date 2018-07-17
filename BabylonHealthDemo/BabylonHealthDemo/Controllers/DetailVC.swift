import UIKit
import RealmSwift
import CocoaLumberjackSwift

class DetailVC: UIViewController {
  
  var viewModel: PostsVM!
  
  private var navigateButton: UIButton!
  
  override func loadView() {
    super.loadView()
    setup()
  }
  
  func bindViewModel() {
    // TODO: Bindings
  }
  
  private func setup() {
    addUIElements()
    setupStyling()
    setupConstraints()
  }
  
  private func addUIElements() {
    navigateButton = UIButton()
    navigateButton.setTitle("Present new VC", for: .normal)
    navigateButton.addTarget(self, action: #selector(navigate), for: .touchUpInside)
    view.addSubview(navigateButton)
  }
  
  private func setupStyling() {
    view.backgroundColor = .white
  }
  
  private func setupConstraints() {
    navigateButton.translatesAutoresizingMaskIntoConstraints = true
    navigateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    navigateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
  
  @objc private func navigate() {
    //viewModel.navigatePressed()
  }
}
