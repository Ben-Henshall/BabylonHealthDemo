import UIKit

struct TitleTableViewCellModel {
  let title: String
  let useAltBackground: Bool
  
  init(post: Post, useAltBackground: Bool) {
    self.title = post.title
    self.useAltBackground = useAltBackground
  }
}

class TitleTableViewCell: UITableViewCell {

  private var didSetupConstraints: Bool = false
  var titleLabel: UILabel!
  
  init() {
    super.init(style: .default, reuseIdentifier: TitleTableViewCell.reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func configure(model: TitleTableViewCellModel) {
    titleLabel?.text = model.title
    backgroundColor = model.useAltBackground ? .powderBlue : .white
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
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 2
    contentView.addSubview(titleLabel)
    
    let coloredView = UIView()
    coloredView.backgroundColor = .pastelBlue
    selectedBackgroundView = coloredView
  }
  
  private func setupStyling() {
    titleLabel.font = .h3
    titleLabel.textColor = .titleBlue
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    if !didSetupConstraints {
      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
      titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
      titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
      titleLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
    }
  }
}

extension TitleTableViewCell: Reusable { }
