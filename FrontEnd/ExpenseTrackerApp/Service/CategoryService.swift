import Foundation

class CategoryService {
    static let shared = CategoryService()

    // Fetch all categories
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/categories") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        NetworkManager.shared.get(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let categories = try JSONDecoder().decode([Category].self, from: data)
                    completion(.success(categories))
                } catch {
                    completion(.failure(error))
                } 
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Add a new category
    func addCategory(category: Category, completion: @escaping (Result<Category, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/categories") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        do {
            let body = try JSONEncoder().encode(category)
            NetworkManager.shared.post(url: url, body: body) { result in
                switch result {
                case .success(let data):
                    do {
                        let createdCategory = try JSONDecoder().decode(Category.self, from: data)
                        completion(.success(createdCategory))
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

    // Update an existing category
    func updateCategory(category: Category, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/categories/\(category.categoryID)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        do {
            let body = try JSONEncoder().encode(category)
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

    // Delete a category
    func deleteCategory(categoryID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/categories/\(categoryID)") else {
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
