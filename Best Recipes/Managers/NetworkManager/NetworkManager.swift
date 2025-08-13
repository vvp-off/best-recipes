//
//  NetworkManager.swift
//  Best Recipes
//
//  Created by Иван Семенов on 13.08.2025.
//

import Foundation

enum NetworkError: Error {
    case transportError(Error)
    case serverError(statusCode: Int)
    case noData
    case decodingError(Error)
}

class NetworkManager {
    static let shared = NetworkManager()
    private init () { }
    
    // MARK: - Private Methods
    
    /// Create URL for API method
    private func makeURL(
        for endpoint: Endpoint,
        with query: String? = nil
    ) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = endpoint.path
        
        components.queryItems = makeParameters(for: endpoint, with: query).compactMap {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        return components.url
    }
    
    /// Make dictionary of parameters for URL request
    private func makeParameters(
        for endpoint: Endpoint,
        with query: String?
    ) -> [String: String] {
        var parameters = [String: String]()
        parameters["apiKey"] = API.apiKey
        
        switch endpoint {
        case .getRandomRecipes:
            parameters["number"] = "10"
        case .searchRecipes:
            if let query = query?.trimmingCharacters(in: .whitespacesAndNewlines), !query.isEmpty {
                parameters["query"] = query
            }
            parameters["number"] = "10"
        case .getPopularRecipes:
            parameters["sort"] = "popularity"
            parameters["number"] = "10"
        case .getRecipesForMealType(let type):
            parameters["type"] = type
            parameters["number"] = "10"
        case .getRecipeInfoBulk(let ids):
            parameters["ids"] = ids.map{ "\($0)" }.joined(separator: ",")
        default:
            break
        }
        return parameters
    }
    
    /// Method for making task
    private func makeTask<T: Codable>(
        for url: URL,
        using session: URLSession = .shared,
        completion: @escaping(Result<T, NetworkError>) -> Void
    ) {
        session.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(.transportError(error)))
                return
            }
            guard let http = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            guard (200...299).contains(http.statusCode) else {
                completion(.failure(.serverError(statusCode: http.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodeData = try decoder.decode(T.self, from: data)
                completion(.success(decodeData))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
