import UIKit
import RealmSwift
import CocoaLumberjackSwift
import RxSwift

private let TitleCellReuseIdentifier: String = "TitleCellReuseIdentifier"

class PostsVC: UIViewController {
  
  private let disposeBag = DisposeBag()
  
  var viewModel: PostsVM!

  private var postsTableView: UITableView!

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
    viewModel.posts.drive(postsTableView.rx.items) { tableView, index, post in
      let cell = TitleTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: TitleCellReuseIdentifier)
      cell.configure(model: TitleTableViewCellModel(post: post))
      return cell
    }
    .disposed(by: disposeBag)
  }
  
  private func addUIElements() {
    postsTableView = UITableView(frame: .zero, style: .plain)
    postsTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleCellReuseIdentifier)
//    postsTableView.estimatedRowHeight = 40
//    postsTableView.backgroundColor = .clear
//    postsTableView.sectionIndexColor = .clear
//    postsTableView.tintColor = .clear
//    postsTableView.alwaysBounceVertical = false
//    postsTableView.allowsSelection = false
//    postsTableView.separatorStyle = .none
//    postsTableView.contentInsetAdjustmentBehavior = .never
//    postsTableView.contentInset = .zero
    view.addSubview(postsTableView)
  }
  
  private func setupStyling() {
    view.backgroundColor = .white
  }
  
  private func setupConstraints() {
    postsTableView.translatesAutoresizingMaskIntoConstraints = false
    postsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    postsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    postsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    postsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

  }
}
