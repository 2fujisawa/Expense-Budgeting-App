import Foundation

struct Alert: Identifiable, Codable {
    var id: UUID { UUID() } // Used for SwiftUI's ForEach
    var alertID: Int
    var userID: Int
    var message: String
}
