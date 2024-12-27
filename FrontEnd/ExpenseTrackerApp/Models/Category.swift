struct Category: Identifiable, Codable {
    var id: Int { categoryID } // Conformance to `Identifiable`
    var categoryID: Int        // Matches "categoryID" in JSON
    var name: String           // Matches "name" in JSON
    var description: String?  // Matches "description" in JSON
}
