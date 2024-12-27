import SwiftUI

struct CategoryCardView: View {
    let category: Category

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                // Category Name
                Text(category.name)
                    .font(.headline)
                    .foregroundColor(.white)

                // Description
                if let description = category.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(2) // Limit description to 2 lines
                } else {
                    Text("No description available.")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                        .italic()
                }
            }
            .padding()
            Spacer()
        }
        .frame(height: 100) // Fixed height for consistent card sizes
        .background(Color.green)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}
