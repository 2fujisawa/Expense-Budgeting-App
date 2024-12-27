import SwiftUI

struct TransactionCardView: View {
    let transaction: Transaction

    var body: some View {
        VStack(alignment: .leading) {
            Text(transaction.description)
                .font(.headline)
            Text("Amount: $\(transaction.amount, specifier: "%.2f")")
                .font(.subheadline)
            Text("Date: \(transaction.transactionDate)")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
