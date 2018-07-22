import UIKit
import RxSwift

extension UIViewController {
  /// Display an alert with a given message and action
  ///
  /// - Parameter contents: A model of the information to display on the alert
  /// - Returns: A completable that completes once the alert has been closed
  func alert(contents: AlertContents) -> Completable {
    return Completable.create { [weak self] completable in
      let alertVC = UIAlertController(contents: contents)
      
      alertVC.addAction(UIAlertAction(title: contents.actionTitle, style: .default, handler: { _ in
        contents.action?()
        completable(.completed)
      }))
      
      self?.present(alertVC, animated: true, completion: nil)
      return Disposables.create()
    }
  }
}

extension UIAlertController {
  convenience init(contents: AlertContents) {
    self.init(title: contents.title, message: contents.text, preferredStyle: .alert)
  }
}
