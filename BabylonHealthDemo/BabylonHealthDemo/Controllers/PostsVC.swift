import UIKit
import CocoaLumberjackSwift
import RxSwift

private let TitleCellReuseIdentifier: String = "TitleCellReuseIdentifier"
private let TableViewRefreshTimer: RxTimeInterval = 0.2

class PostsVC: UIViewController {
  private let disposeBag = DisposeBag()
  var viewModel: PostsVM!
  // TODO: Power tableView using RxDatasources to allow better insertion of cells
  // as well as better control of multiple sections
  // TODO: Add second cell type containing a "Load more" button, then loads the next
  // X number of posts.
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
    viewModel.posts
      .debounce(TableViewRefreshTimer)
      .drive(postsTableView.rx.items) { _, _, post in
        let cell = TitleTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: TitleCellReuseIdentifier)
        cell.configure(model: PostTitleTableViewCellModel(post: post))
        return cell
      }
      .disposed(by: disposeBag)
    
    viewModel.alertStream
      .filter { $0 != nil }
      .flatMap { [weak self] contents -> Completable in
        guard let this = self, let contents = contents else { return Completable.empty() }
        return this.alert(contents: contents)
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    postsTableView.rx.modelSelected(Post.self)
      .subscribe(viewModel.postSelected)
      .disposed(by: disposeBag)
  }
  
  private func addUIElements() {
    postsTableView = UITableView(frame: .zero, style: .plain)
    postsTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleCellReuseIdentifier)
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
