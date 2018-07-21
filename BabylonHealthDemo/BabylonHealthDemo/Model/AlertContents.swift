struct AlertContents {
  var title: String
  var text: String?
  var actionTitle: String
  var action: (() -> Void)?
}
