import UIKit

private let RegularFontName = "HelveticaNeue"
private let ThinFontName = "\(RegularFontName)-Light"
private let BoldFontName = "\(RegularFontName)-Bold"

/// Extension to store font styles using static constants.
extension UIFont {
  
  static let h1 = UIFont(name: ThinFontName, size: 16)!
  static let h2 = UIFont(name: ThinFontName, size: 30)!
  static let h3 = UIFont(name: RegularFontName, size: 22)!

}
