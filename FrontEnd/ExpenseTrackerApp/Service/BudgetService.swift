import Foundation

class BudgetService {
    static let shared = BudgetService()
    private init() {}

    // Fetch budgets for a user
    func fetchBudgets(for userID: Int, completion: @escaping (Result<[Budget], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/budgets/\(userID)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        NetworkManager.shared.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let budgets = try JSONDecoder().decode([Budget].self, from: data)
                    completion(.success(budgets))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Add a budget for a user
    func addBudget(for userID: Int, budget: Budget, completion: @escaping (Result<Budget, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/budgets") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        do {
            var budgetToSend = budget
            budgetToSend.userID = userID // Ensure the userID is assigned
            let body = try JSONEncoder().encode(budgetToSend)
            NetworkManager.shared.post(url: url, body: body) { result in
                switch result {
                case .success(let data):
                    do {
                        let createdBudget = try JSONDecoder().decode(Budget.self, from: data)
                        completion(.success(createdBudget))
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // Update a budget
    func updateBudget(budget: Budget, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/budgets/\(budget.budgetID)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        do {
            let body = try JSONEncoder().encode(budget)
            NetworkManager.shared.put(url: url, body: body) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    // Delete a budget
    func deleteBudget(budgetID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/budgets/\(budgetID)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        NetworkManager.shared.delete(url: url) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
