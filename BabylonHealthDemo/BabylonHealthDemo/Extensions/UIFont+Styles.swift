import UIKit

private let RegularFontName = "HelveticaNeue"
private let ThinFontName = "\(RegularFontName)-Light"

/// Extension to store font styles using static constants.
extension UIFont {
  // TODO: Refactor these to be ascending size
  static let h1 = UIFont(name: ThinFontName, size: 30)!
  static let h2 = UIFont(name: RegularFontName, size: 22)!
  static let h3 = UIFont(name: ThinFontName, size: 16)!
}
