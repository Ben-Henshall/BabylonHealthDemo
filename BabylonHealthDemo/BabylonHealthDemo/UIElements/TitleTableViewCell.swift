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
    //title = post.title
    //body = post.body
    title = "postID: \(post.id)"
    body = "userID: \(post.userID)"
  }
  
  // TODO: Delete if not relevent
  init(user: User) {
    title = "username: \(user.username)"
    body = "userID: \(user.id)"
  }
  
  // TODO: Delete if not relevent
  init(comment: Comment) {
    title = "postID: \(comment.postID)"
    body = "commentID: \(comment.id)"
  }
}
