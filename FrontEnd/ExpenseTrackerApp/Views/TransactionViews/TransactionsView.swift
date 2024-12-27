import SwiftUI

struct TransactionsView: View {
    let userID: Int
    @Binding var transactions: [Transaction]
    @Binding var budgets: [Budget]
    @State private var categories: [Category] = [] // Add categories state
    @State private var showingAddTransaction = false

    var body: some View {
        VStack {
            if transactions.isEmpty {
                Text("No transactions available.")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(transactions) { transaction in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(transaction.description)
                                .font(.headline)
                            Text("Amount: $\(transaction.amount, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(transaction.type == "Income" ? .green : .red)
                        }
                    }
                    .onDelete(perform: deleteTransaction)
                }
            }

            Spacer()

            Button(action: { showingAddTransaction = true }) {
                Text("Add Transaction")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Transactions")
        .sheet(isPresented: $showingAddTransaction) {
            TransactionFormView(userID: userID, transactions: $transactions, budgets: $budgets, categories: $categories)
        }
        .onAppear(perform: loadData) // Load data on appear
    }

    private func loadData() {
        loadCategories()
    }

    private func loadCategories() {
        CategoryService.shared.fetchCategories { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCategories):
                    categories = fetchedCategories
                case .failure(let error):
                    print("Error fetching categories: \(error.localizedDescription)")
                }
            }
        }
    }

    private func deleteTransaction(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let transactionID = transactions[index].transactionID
        TransactionService.shared.deleteTransaction(transactionID: transactionID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    transactions.remove(atOffsets: offsets)
                case .failure(let error):
                    print("Error deleting transaction: \(error.localizedDescription)")
                }
            }
        }
    }
}
