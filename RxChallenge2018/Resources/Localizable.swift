import Foundation

extension String {
    static var str_error: String { return NSLocalizedString("str_error", comment: "Error") }
    static var str_posts: String { return NSLocalizedString("str_posts", comment: "Posts") }
    static var str_search_posts: String { return NSLocalizedString("str_search_posts", comment: "Search post") }
    static var str_error_loading_data: String { return NSLocalizedString("str_error_loading_data", comment: "Error loading information. Please, check your internet connection and try again.") }
    static var str_post_details: String { return NSLocalizedString("str_post_details", comment: "Post detail") }
    static var str_by_user_username: String { return NSLocalizedString("str_by_user_username", comment: "By $var1 (@$var2)") }
    static var str_x_comments: String { return NSLocalizedString("str_x_comments", comment: "$var1 comments") }
}
