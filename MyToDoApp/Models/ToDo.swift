import Foundation

struct ToDo: Codable {
    var taskID: String
    var name: String
    var description: String
    var status: Int
    var createdBy: String
}
