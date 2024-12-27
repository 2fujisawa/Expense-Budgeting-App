import Foundation

class AlertService {
    static let shared = AlertService()

    func fetchAlerts(for userID: Int, completion: @escaping (Result<[Alert], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/alerts/\(userID)") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            do {
                let alerts = try JSONDecoder().decode([Alert].self, from: data)
                completion(.success(alerts))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
