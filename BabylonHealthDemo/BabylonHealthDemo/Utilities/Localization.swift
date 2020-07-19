import Foundation

/// Namespacing for localised strings
public enum Localization {
  public enum Posts {
    public static var title: String { localizedString("post_screen_title") }
  }
  
  public enum PostDetail {
    public static var title: String { localizedString("post_detail_screen_title") }
    public static var author: String { localizedString("post_detail_screen_author") }
    public static var body: String { localizedString("post_detail_screen_body") }
    public static var numberOfComments: String { localizedString("post_detail_screen_num_of_comments") }
  }
  
  public enum Error {
    public static var genericTitle: String { localizedString("alert_error") }
    public static var ok: String { localizedString("alert_ok") }
  }
}

private func localizedString(
  _ identifier: String,
  comment: String = ""
) -> String {
  NSLocalizedString(identifier, comment: comment)
}
