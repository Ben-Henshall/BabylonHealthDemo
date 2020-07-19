import UIKit
import CocoaLumberjackSwift
import RxSwift

private let TableViewRefreshTimer: RxTimeInterval = 0.2

class PostsVC: UIViewController {
  private let disposeBag = DisposeBag()
  var viewModel: PostsVM!
  
  // TODO: Power tableView using RxDatasources to allow better insertion of cells
  // as well as better control of multiple sections
  // TODO: Add second cell type containing a "Load more" button, then loads the next
  // X number of posts.
  
  private var postsTableView: UITableView!
  private var activityIndicator: UIActivityIndicatorView!
  private var refreshControl: UIRefreshControl!
  
  private var didSetupConstraints: Bool = false
  
  init(viewModel: PostsVM) {
    super.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // Deselect rows when we navigate back to this VC
    postsTableView.indexPathsForSelectedRows?.forEach {
      postsTableView.deselectRow(at: $0, animated: true)
    }
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
    viewModel.title
      .drive(rx.title)
      .disposed(by: disposeBag)
    
    viewModel.posts
      // Debounce to prevent quick animations from cached version to live version of data
      .debounce(TableViewRefreshTimer)
      .do(onNext: { [weak self] _ in
        guard let strongSelf = self else { return }
        strongSelf.refreshControl.endRefreshing()
      })
      .drive(postsTableView.rx.items) { _, row, post in
        let useAltBackground = row % 2 == 0
        let cell = TitleTableViewCell()
        cell.configure(model: TitleTableViewCellModel(post: post, useAltBackground: useAltBackground))
        return cell
      }
      .disposed(by: disposeBag)
    
    viewModel.alertStream
      .filter { $0 != nil }
      .flatMap { [weak self] contents -> Completable in
        guard let strongSelf = self, let contents = contents else { return Completable.empty() }
        return strongSelf.alert(contents: contents)
      }
      .subscribe()
      .disposed(by: disposeBag)
    
    postsTableView.rx.modelSelected(Post.self)
      .subscribe(viewModel.postSelected)
      .disposed(by: disposeBag)
    
    let hasLoaded = viewModel.posts
      .map { !$0.isEmpty }
      .filter { $0 }
    
    hasLoaded
      .drive(activityIndicator.rx.isHidden)
      .disposed(by: disposeBag)
    
    hasLoaded
      .map { !$0 }
      .drive(activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)
    
    postsTableView.refreshControl!.rx
      .controlEvent(.valueChanged)
      .bind(to: viewModel.pullNewData)
      .disposed(by: disposeBag)
  }
  
  private func addUIElements() {
    postsTableView = UITableView(frame: .zero, style: .plain)
    postsTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier)
    view.addSubview(postsTableView)
    
    activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
    
    refreshControl = UIRefreshControl()
    postsTableView.refreshControl = refreshControl
  }
  
  private func setupStyling() {
    postsTableView.separatorStyle = .none
    view.backgroundColor = .white
    activityIndicator.color = .titleBlue
    refreshControl.tintColor = .titleBlue
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    if !didSetupConstraints {
      postsTableView.translatesAutoresizingMaskIntoConstraints = false
      postsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
      postsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
      postsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      postsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.centerXAnchor.constraint(equalTo: postsTableView.centerXAnchor).isActive = true
      activityIndicator.centerYAnchor.constraint(equalTo: postsTableView.centerYAnchor).isActive = true
    }
  }
}
