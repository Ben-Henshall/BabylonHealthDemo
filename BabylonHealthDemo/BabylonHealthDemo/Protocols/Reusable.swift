import UIKit

protocol Reusable: class {
  /// Reuse identifier of the cell
  static var reuseIdentifier: String { get }
}

extension Reusable {
  static var reuseIdentifier: String {
    return String(describing: Self.self)
  }
}
