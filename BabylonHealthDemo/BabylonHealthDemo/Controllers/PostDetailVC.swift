import UIKit
import CocoaLumberjackSwift
import RxSwift
import RxCocoa

class PostDetailVC: UIViewController {
  private let disposeBag = DisposeBag()
  var viewModel: PostDetailVM!
  
  private var tableView: UITableView!

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
      .filter { !$0.isEmpty }
      .withLatestFrom(viewModel.authorCellTitle) { detail, cellTitle in
        return DetailedTableViewCellModel(title: cellTitle, detail: detail)
      }
    
    let bodyCell = viewModel.body
      .filter { !$0.isEmpty }
      .withLatestFrom(viewModel.bodyCellTitle) { detail, cellTitle in
        return DetailedTableViewCellModel(title: cellTitle, detail: detail)
      }
    
    let numberOfCommentsCell = viewModel.numberOfComments
      .map { "\($0)" }
      .withLatestFrom(viewModel.numberOfCommentsCellTitle) { detail, cellTitle in
        return DetailedTableViewCellModel(title: cellTitle, detail: detail)
      }

    let latest = Driver.combineLatest(authorCell, bodyCell, numberOfCommentsCell) {
      return [$0, $1, $2]
    }
    
    latest
      .drive(tableView.rx.items) { _, _, model in
        let cell = DetailedTitleTableViewCell()
        cell.configure(model: model)
        return cell
      }
      .disposed(by: disposeBag)
  }
  
  private func addUIElements() {
    tableView = UITableView(frame: .zero, style: .plain)
    tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier)
    view.addSubview(tableView)
  }
  
  private func setupStyling() {
    tableView.separatorStyle = .none
    view.backgroundColor = .white
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
  }
}
