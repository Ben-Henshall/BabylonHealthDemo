import UIKit
import RealmSwift
import CocoaLumberjackSwift

class PostsVC: UIViewController {
  
  var viewModel: PostsVM!

  private var popButton: UIButton!
  private var rootButton: UIButton!
  private var pushButton: UIButton!
  private var modalButton: UIButton!

  init(viewModel: PostsVM) {
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
    setupConstraints()
    bindViewModel()
  }
  
  func bindViewModel() {
    // TODO: Bindings
  }
  
  private func addUIElements() {
    popButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    popButton.setTitle("pop", for: .normal)
    popButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
    view.addSubview(popButton)
    
    rootButton = UIButton()
    rootButton.setTitle("root", for: .normal)
    rootButton.addTarget(self, action: #selector(root), for: .touchUpInside)
    view.addSubview(rootButton)
    
    pushButton = UIButton()
    pushButton.setTitle("push", for: .normal)
    pushButton.addTarget(self, action: #selector(push), for: .touchUpInside)
    view.addSubview(pushButton)
    
    modalButton = UIButton()
    modalButton.setTitle("modal", for: .normal)
    modalButton.addTarget(self, action: #selector(modal), for: .touchUpInside)
    view.addSubview(modalButton)
  }
  
  private func setupStyling() {
    view.backgroundColor = .white
    popButton.backgroundColor = .red
    rootButton.backgroundColor = .red
    pushButton.backgroundColor = .red
    modalButton.backgroundColor = .red
  }
  
  private func setupConstraints() {
    popButton.translatesAutoresizingMaskIntoConstraints = false
    popButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    popButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    rootButton.translatesAutoresizingMaskIntoConstraints = false
    rootButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    rootButton.topAnchor.constraint(equalTo: popButton.bottomAnchor, constant: 16).isActive = true
    
    pushButton.translatesAutoresizingMaskIntoConstraints = false
    pushButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    pushButton.topAnchor.constraint(equalTo: rootButton.bottomAnchor, constant: 16).isActive = true
    
    modalButton.translatesAutoresizingMaskIntoConstraints = false
    modalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    modalButton.topAnchor.constraint(equalTo: pushButton.bottomAnchor, constant: 16).isActive = true
  }
  
  @objc private func pop() {
    viewModel.pop()
  }
  
  @objc private func root() {
    viewModel.root()
  }
  
  @objc private func push() {
    viewModel.push()
  }
  
  @objc private func modal() {
    viewModel.modal()
  }
}

class TestModel: Object {
  // MARK: - Properties
  @objc dynamic var id: Int = 0
  @objc dynamic var test = "test text"
  
  // MARK: - Meta
  override static func primaryKey() -> String? {
    return "id"
  }
}
