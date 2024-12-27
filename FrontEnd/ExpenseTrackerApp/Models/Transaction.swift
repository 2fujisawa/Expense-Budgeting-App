import Foundation

struct Transaction: Identifiable, Codable {
    var id: Int { transactionID } // Conform to `Identifiable` using `transactionID`
    var transactionID: Int        // Unique transaction ID
    var userID: Int               // Links to the User table
    var budgetID: Int?            // Links to the Budget table (optional)
    var amount: Double            // Transaction amount
    var transactionDate: String   // Use `String` to match the backend's date format
    var categoryID: Int           // Links to the Category table
    var description: String       // Description of the transaction
    var type: String              // "Expense" or "Income"
}
