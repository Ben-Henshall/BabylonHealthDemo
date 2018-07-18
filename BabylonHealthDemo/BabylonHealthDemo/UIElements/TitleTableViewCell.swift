import UIKit

class TitleTableViewCell: UITableViewCell {
  public func configure(model: TitleTableViewCellModel) {
    textLabel?.text = model.title
  }
}

struct TitleTableViewCellModel {
  let title: String
  
  init(post: Post) {
    title = post.title
  }
}
