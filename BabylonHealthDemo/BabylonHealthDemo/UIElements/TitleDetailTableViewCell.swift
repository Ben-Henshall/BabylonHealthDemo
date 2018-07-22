import UIKit

class TitleDetailTableViewCell: UITableViewCell, Reusable {

  private var titleLabel: UILabel!
  
  // TODO: Override selected and perform animation
  
  init() {
    super.init(style: .default, reuseIdentifier: TitleDetailTableViewCell.reuseIdentifier)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public func configure(model: TitleTableViewCellModel) {
    titleLabel?.text = model.title
    detailTextLabel?.text = model.body
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
    titleLabel.font = .h1
    titleLabel.textColor = .titleBlue
    selectionStyle = .gray
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
    titleLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
  }
}

struct TitleTableViewCellModel {
  let title: String
  let body: String
  let useAltBackground: Bool
  
  init(post: Post, useAltBackground: Bool) {
    //title = post.title
    //body = post.body
    title = post.title
    body = post.body
    self.useAltBackground = useAltBackground
  }
  
  // TODO: Delete if not relevent
  init(user: User, useAltBackground: Bool) {
    title = "username: \(user.username)"
    body = "userID: \(user.id)"
    self.useAltBackground = useAltBackground
  }
  
  // TODO: Delete if not relevent
  init(comment: Comment, useAltBackground: Bool) {
    title = "postID: \(comment.postID)"
    body = "commentID: \(comment.id)"
    self.useAltBackground = useAltBackground
  }
}

//class PostTitleTableViewCellModel: TitleTableViewCellModel {
//  convenience init(post: Post) {
//    self.init(title: "postID: \(post.id)", body: "userID: \(post.userID)")
//  }
//}


