import UIKit
import RxSwift

extension UIViewController {
  func alert(contents: AlertContents) -> Completable {
    return Completable.create { [weak self] completable in
      let alertVC = UIAlertController(title: contents.title, message: contents.text, preferredStyle: .alert)
      
      alertVC.addAction(UIAlertAction(title: contents.actionTitle, style: .default, handler: { _ in
        contents.action?()
        completable(.completed)
      }))
      
      self?.present(alertVC, animated: true, completion: nil)
      return Disposables.create()
    }
  }
}
