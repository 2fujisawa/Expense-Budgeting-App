import SwiftUI

struct BudgetsView: View {
    let userID: Int
    @Binding var budgets: [Budget]
    @Binding var transactions: [Transaction] // Binding to access transactions
    @Binding var alerts: [Alert] // Binding to access alerts
    @State private var showingAddBudget = false
    @State private var editingBudget: Budget?

    var body: some View {
        VStack {
            if budgets.isEmpty {
                Text("No budgets available.")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(budgets) { budget in
                        BudgetCardView(
                            budget: budget,
                            transactions: transactions, // Pass transactions to BudgetCardView
                            alerts: alerts // Pass alerts to BudgetCardView
                        ) { selectedBudget in
                            editingBudget = selectedBudget
                        }
                    }
                    .onDelete(perform: deleteBudget)
                }
            }
            Spacer()

            Button(action: { showingAddBudget = true }) {
                Text("Add Budget")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .navigationTitle("Budgets")
        .sheet(isPresented: $showingAddBudget) {
            BudgetFormView(userID: userID, budgets: $budgets)
        }
        .sheet(item: $editingBudget) { budget in
            BudgetFormView(userID: userID, budgets: $budgets, budget: budget)
        }
        .onAppear(perform: loadBudgets)
    }

    private func loadBudgets() {
        BudgetService.shared.fetchBudgets(for: userID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedBudgets):
                    budgets = fetchedBudgets
                case .failure(let error):
                    print("Error loading budgets: \(error.localizedDescription)")
                }
            }
        }
    }

    private func deleteBudget(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let budgetID = budgets[index].budgetID
        BudgetService.shared.deleteBudget(budgetID: budgetID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    budgets.remove(atOffsets: offsets)
                case .failure(let error):
                    print("Error deleting budget: \(error.localizedDescription)")
                }
            }
        }
    }
}
