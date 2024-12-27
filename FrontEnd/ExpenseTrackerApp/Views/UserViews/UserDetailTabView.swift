import SwiftUI

struct UserDetailsTabView: View {
    let userID: Int
    let userName: String
    
    @State private var budgets: [Budget] = []
    @State private var transactions: [Transaction] = []
    @State private var alerts: [Alert] = []
    @State private var isLoading = true
    
    var body: some View {
        TabView {
            BudgetsView(userID: userID, budgets: $budgets, transactions: $transactions, alerts: $alerts) // Pass alerts here
                .tabItem {
                    Label("Budgets", systemImage: "wallet.pass")
                }
            TransactionsView(userID: userID, transactions: $transactions, budgets: $budgets)
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet")
                }
            AlertsView(userID: userID, alerts: $alerts)
                .tabItem {
                    Label("Alerts", systemImage: "bell")
                }
            CategoryView()
                .tabItem {
                    Label("Categories", systemImage: "folder")
                }
        }
        .accentColor(.green)
        .navigationTitle("\(userName)'s Dashboard")
        .onAppear(perform: loadUserData)
    }
    
    private func loadUserData() {
        isLoading = true
        BudgetService.shared.fetchBudgets(for: userID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedBudgets):
                    budgets = fetchedBudgets
                case .failure(let error):
                    print("Error fetching budgets: \(error.localizedDescription)")
                }
                isLoading = false
            }
        }
        TransactionService.shared.fetchTransactions(for: userID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedTransactions):
                    transactions = fetchedTransactions
                case .failure(let error):
                    print("Error fetching transactions: \(error.localizedDescription)")
                }
            }
        }
        AlertService.shared.fetchAlerts(for: userID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedAlerts):
                    alerts = fetchedAlerts
                case .failure(let error):
                    print("Error fetching alerts: \(error.localizedDescription)")
                }
            }
        }
    }
}
