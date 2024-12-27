import Foundation

struct Budget: Identifiable, Codable {
    let budgetID: Int
    var userID: Int
    let startDate: String
    let endDate: String
    let monthlyLimit: Double
    let status: String

    var name: String? // Optional or default property for display
    var id: Int { budgetID } // Conforming to Identifiable
}
