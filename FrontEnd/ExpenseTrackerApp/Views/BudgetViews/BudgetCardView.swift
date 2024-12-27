import SwiftUI

struct BudgetCardView: View {
    let budget: Budget
    let transactions: [Transaction] // Pass transactions to calculate spending
    let alerts: [Alert] // Pass alerts for display
    let onEdit: (Budget) -> Void // Callback for editing

    var body: some View {
        // Calculate the total amount used for this budget
        let amountUsed = transactions
            .filter { $0.budgetID == budget.budgetID } // Filter transactions by budgetID
            .reduce(0) { $0 + $1.amount } // Sum the amounts of the filtered transactions

        // Check if there's an active alert for this budget
        let relevantAlerts = alerts.filter { alert in
            alert.message.contains("Budget \(budget.budgetID)") // Adjust based on your alert messages
        }
        let alertMessage = relevantAlerts.last?.message

        VStack(alignment: .leading, spacing: 10) {
            // Budget name
            Text(budget.name ?? "Unnamed Budget")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            // Monthly limit and amount used
            Text("Monthly Limit: $\(budget.monthlyLimit, specifier: "%.2f")")
                .font(.headline)

            let percentageUsed = min((amountUsed / budget.monthlyLimit) * 100, 100)

            HStack {
                Text("Used: $\(amountUsed, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer()
                Text("\(percentageUsed, specifier: "%.0f")% Used")
                    .font(.subheadline)
                    .foregroundColor(percentageUsed > 100 ? .red : .green)
            }

            ProgressView(value: percentageUsed, total: 100)
                .accentColor(percentageUsed > 100 ? .red : .green)

            if let alertMessage = alertMessage {
                // Show the latest alert message
                Text(alertMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }

            HStack {
                Spacer()
                Button(action: { onEdit(budget) }) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.vertical, 5)
    }
}
