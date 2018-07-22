import UIKit
import CocoaLumberjackSwift
import RxSwift

class PostDetailVC: UIViewController {
  private let disposeBag = DisposeBag()
  var viewModel: PostDetailVM!
  
  var centerLabel: UILabel!

  init(viewModel: PostDetailVM) {
    super.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    setup()
  }
  
  private func setup() {
    addUIElements()
    setupStyling()
    bindViewModel()
    updateViewConstraints()
  }
  
  func bindViewModel() {
    // TODO
  }
  
  private func addUIElements() {
    centerLabel = UILabel()
    centerLabel.text = "Center"
    view.addSubview(centerLabel)
    
    viewModel.title
      .drive(rx.title)
      .disposed(by: disposeBag)
  }
  
  private func setupStyling() {
    view.backgroundColor = .white
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    centerLabel.translatesAutoresizingMaskIntoConstraints = false
    centerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    centerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
  }
}
