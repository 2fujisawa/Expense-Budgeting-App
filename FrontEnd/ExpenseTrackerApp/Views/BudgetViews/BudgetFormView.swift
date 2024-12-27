import SwiftUI

struct BudgetFormView: View {
    let userID: Int
    @Binding var budgets: [Budget]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var budgetName: String = ""
    @State private var monthlyLimit: String = ""
    @State private var startDate: String = "2024-01-01"
    @State private var endDate: String = "2024-12-31"
    
    var budget: Budget? // Optional for editing

    var body: some View {
        Form {
            TextField("Budget Name (Optional)", text: $budgetName)
            TextField("Monthly Limit", text: $monthlyLimit)
                .keyboardType(.decimalPad)
            TextField("Start Date", text: $startDate)
            TextField("End Date", text: $endDate)
            
            Button("Save Budget") {
                saveBudget()
            }
        }
        .navigationTitle(budget == nil ? "Add Budget" : "Edit Budget")
        .onAppear {
            if let budget = budget {
                budgetName = budget.name ?? ""
                monthlyLimit = "\(budget.monthlyLimit)"
                startDate = budget.startDate
                endDate = budget.endDate
            }
        }
    }
    
    private func saveBudget() {
        guard let monthlyLimitValue = Double(monthlyLimit) else {
            print("Invalid monthly limit")
            return
        }
        let newBudget = Budget(
            budgetID: budget?.budgetID ?? Int.random(in: 1...1000),
            userID: userID,
            startDate: startDate,
            endDate: endDate,
            monthlyLimit: monthlyLimitValue,
            status: "Active",
            name: budgetName.isEmpty ? nil : budgetName
        )
        
        if budget == nil {
            // Add a new budget
            BudgetService.shared.addBudget(for: userID, budget: newBudget) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let addedBudget):
                        budgets.append(addedBudget)
                        presentationMode.wrappedValue.dismiss()
                    case .failure(let error):
                        print("Error adding budget: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            // Update an existing budget
            BudgetService.shared.updateBudget(budget: newBudget) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        if let index = budgets.firstIndex(where: { $0.budgetID == newBudget.budgetID }) {
                            budgets[index] = newBudget
                        }
                        presentationMode.wrappedValue.dismiss()
                    case .failure(let error):
                        print("Error updating budget: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
