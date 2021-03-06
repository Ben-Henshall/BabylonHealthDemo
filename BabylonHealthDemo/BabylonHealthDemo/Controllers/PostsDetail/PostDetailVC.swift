import UIKit
import CocoaLumberjackSwift
import RxSwift
import RxCocoa

class PostDetailVC: UIViewController {
  private let disposeBag = DisposeBag()
  var viewModel: PostDetailVM!
  
  private var tableView: UITableView!
  private var activityIndicator: UIActivityIndicatorView!
  private var didSetupConstraints: Bool = false

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
    let authorCell = viewModel.author
      .filter(\.isEmpty.isFalse)
      .withLatestFrom(viewModel.authorCellTitle) { detail, cellTitle in
        return DetailedTableViewCellModel(title: cellTitle, detail: detail, useLargeDetail: true)
      }
    
    let bodyCell = viewModel.body
      .filter(\.isEmpty.isFalse)
      .withLatestFrom(viewModel.bodyCellTitle) { detail, cellTitle in
        return DetailedTableViewCellModel(title: cellTitle, detail: detail, useLargeDetail: false)
      }

    let numberOfCommentsCell = viewModel.numberOfComments
      .map(String.init)
      .withLatestFrom(viewModel.numberOfCommentsCellTitle) { detail, cellTitle in
        return DetailedTableViewCellModel(title: cellTitle, detail: detail, useLargeDetail: true)
      }

    let cells = [authorCell, bodyCell, numberOfCommentsCell]
    
    let latest = Driver.combineLatest(cells)
    
    latest
      .drive(tableView.rx.items) { _, _, model in
        let cell = DetailedTitleTableViewCell()
        cell.configure(model: model)
        return cell
      }
      .disposed(by: disposeBag)
    
    let hasLoaded = latest
      .map { $0.count == cells.count }
    
    hasLoaded
      .drive(activityIndicator.rx.isHidden)
      .disposed(by: disposeBag)
    
    hasLoaded
      .map(\.isFalse)
      .drive(activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)

    viewModel.alertStream
      .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
      .compactMap(identity)
      .flatMap(alert(contents:))
      .subscribe()
      .disposed(by: disposeBag)
  }
  
  private func addUIElements() {
    tableView = UITableView(frame: .zero, style: .plain)
    tableView.register(DetailedTitleTableViewCell.self, forCellReuseIdentifier: DetailedTitleTableViewCell.reuseIdentifier)
    view.addSubview(tableView)
    
    activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
  }
  
  private func setupStyling() {
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableView.automaticDimension
    tableView.allowsSelection = false
    
    view.backgroundColor = .white
    
    activityIndicator.color = .titleBlue
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    if !didSetupConstraints {
      tableView.translatesAutoresizingMaskIntoConstraints = false
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
      tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      
      activityIndicator.translatesAutoresizingMaskIntoConstraints = false
      activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
      activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }
  }
}
