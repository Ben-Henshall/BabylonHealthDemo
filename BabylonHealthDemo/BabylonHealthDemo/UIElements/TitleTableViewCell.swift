import UIKit

class TitleTableViewCell: UITableViewCell {
  public func configure(model: TitleTableViewCellModel) {
    textLabel?.text = model.title
    detailTextLabel?.text = model.body
  }
}

struct TitleTableViewCellModel {
  let title: String
  let body: String
  
  init(post: Post) {
    title = post.title
    body = post.body
  }
}
