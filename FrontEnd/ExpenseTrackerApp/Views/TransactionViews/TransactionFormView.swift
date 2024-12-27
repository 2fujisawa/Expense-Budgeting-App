import SwiftUI

struct TransactionFormView: View {
    let userID: Int
    @Binding var transactions: [Transaction]
    @Binding var budgets: [Budget] // Pass budgets to associate transactions
    @Binding var categories: [Category] // Add categories binding
    @Environment(\.presentationMode) var presentationMode

    @State private var amount: String = ""
    @State private var transactionDate: String = "2024-01-01"
    @State private var description: String = ""
    @State private var transactionType: String = "Expense"
    @State private var selectedBudgetID: Int?
    @State private var selectedCategoryID: Int?

    var transaction: Transaction? // Optional for editing

    var body: some View {
        Form {
            TextField("Amount", text: $amount)
                .keyboardType(.decimalPad)
            TextField("Date", text: $transactionDate)
            TextField("Description", text: $description)
            
            Picker("Transaction Type", selection: $transactionType) {
                Text("Expense").tag("Expense")
                Text("Income").tag("Income")
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Picker("Select Budget", selection: $selectedBudgetID) {
                ForEach(budgets, id: \.budgetID) { budget in
                    Text(budget.name ?? "Unnamed Budget").tag(budget.budgetID)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Picker("Select Category", selection: $selectedCategoryID) { // Add category picker
                ForEach(categories, id: \.categoryID) { category in
                    Text(category.name).tag(category.categoryID)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Button("Save Transaction") {
                saveTransaction()
            }
        }
        .navigationTitle(transaction == nil ? "Add Transaction" : "Edit Transaction")
        .onAppear {
            if let transaction = transaction {
                amount = "\(transaction.amount)"
                transactionDate = transaction.transactionDate
                description = transaction.description
                transactionType = transaction.type
                selectedBudgetID = transaction.budgetID
                selectedCategoryID = transaction.categoryID
            }
        }
    }
    
    private func saveTransaction() {
        guard let budgetID = selectedBudgetID, let categoryID = selectedCategoryID, let amountValue = Double(amount) else {
            print("Validation failed")
            return
        }

        let newTransaction = Transaction(
            transactionID: transaction?.transactionID ?? Int.random(in: 1...1000),
            userID: userID,
            budgetID: budgetID,
            amount: amountValue,
            transactionDate: transactionDate,
            categoryID: categoryID,
            description: description,
            type: transactionType
        )

        if transaction == nil {
            // Add a new transaction
            TransactionService.shared.addTransaction(for: userID, transaction: newTransaction) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        transactions.append(newTransaction)
                        presentationMode.wrappedValue.dismiss()
                    case .failure(let error):
                        print("Error saving transaction: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
