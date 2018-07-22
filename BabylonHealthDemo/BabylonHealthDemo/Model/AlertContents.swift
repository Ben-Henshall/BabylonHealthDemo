/// Model representing information required to display an AlertController
struct AlertContents {
  var title: String
  var text: String?
  var actionTitle: String
  var action: (() -> Void)?
}

extension AlertContents: Equatable {
  static func == (lhs: AlertContents, rhs: AlertContents) -> Bool {
    return lhs.title == rhs.title &&
      lhs.text == rhs.text &&
      lhs.actionTitle == rhs.actionTitle
  }
}
