import UIKit

class DetailedTitleTableViewCell: UITableViewCell, Reusable {
  
  private var didSetupConstraints: Bool = false
  var titleLabel: UILabel!
  var detailedLabel: UILabel!
  
  init() {
    super.init(style: .default, reuseIdentifier: TitleTableViewCell.reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func configure(model: DetailedTableViewCellModel) {
    titleLabel?.text = model.title
    detailedLabel.text = model.detail
  }
  
  private func setup() {
    addUIElements()
    setupStyling()
    self.setNeedsUpdateConstraints()
  }
  
  private func addUIElements() {
    // Remove the system elements
    textLabel?.removeFromSuperview()
    
    titleLabel = UILabel()
    titleLabel.textAlignment = .left
    titleLabel.numberOfLines = 2
    contentView.addSubview(titleLabel)
    
    detailedLabel = UILabel()
    detailedLabel.textAlignment = .center
    detailedLabel.numberOfLines = 0
    contentView.addSubview(detailedLabel)
  }
  
  private func setupStyling() {
    titleLabel.font = .h1
    titleLabel.textColor = .titleBlue
    
    detailedLabel.font = .h2
    detailedLabel.textColor = .titleBlue
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    if !didSetupConstraints {
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
      titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
      titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
      
      detailedLabel.translatesAutoresizingMaskIntoConstraints = false
      detailedLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
      detailedLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
      detailedLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
      detailedLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 24).isActive = true


    }
  }
}

struct DetailedTableViewCellModel {
  let title: String
  let detail: String
}
