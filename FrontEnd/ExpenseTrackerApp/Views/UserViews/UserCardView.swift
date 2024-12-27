import SwiftUI

struct UserCardView: View {
    let user: User

    var body: some View {
        Text(user.name)
            .font(.headline)
            .foregroundColor(.primary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
            )
            .padding(.horizontal)
    }
}
