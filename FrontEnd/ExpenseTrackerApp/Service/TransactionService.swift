import Foundation

class TransactionService {
    static let shared = TransactionService()

    // Fetch transactions for a user
    func fetchTransactions(for userID: Int, completion: @escaping (Result<[Transaction], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/transactions/\(userID)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        NetworkManager.shared.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let transactions = try JSONDecoder().decode([Transaction].self, from: data)
                    completion(.success(transactions))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Add a new transaction for a user
    func addTransaction(for userID: Int, transaction: Transaction, completion: @escaping (Result<Transaction, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/transactions") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        do {
            var transactionToSend = transaction
            transactionToSend.userID = userID
            let body = try JSONEncoder().encode(transactionToSend)
            NetworkManager.shared.post(url: url, body: body) { result in
                switch result {
                case .success(let data):
                    do {
                        let createdTransaction = try JSONDecoder().decode(Transaction.self, from: data)
                        completion(.success(createdTransaction))
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

    // Update an existing transaction
    func updateTransaction(transaction: Transaction, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/transactions/\(transaction.transactionID)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        do {
            let body = try JSONEncoder().encode(transaction)
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

    // Delete a transaction
    func deleteTransaction(transactionID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/transactions/\(transactionID)") else {
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
