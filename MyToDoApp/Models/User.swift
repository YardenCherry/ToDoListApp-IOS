import Foundation

struct User: Codable {
    var name: String
    var userID: String
    var userEmail: String
    var password: String
    var profileImageUrl: String?
    var tasks: [ToDo] = []
}
