struct User: Identifiable, Codable {
    let id: Int
    let name: String
    let age: Int
    let email: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case id = "userID"
        case name, age, email, status
    }
}
