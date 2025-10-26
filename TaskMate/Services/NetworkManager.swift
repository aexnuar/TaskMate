//
//  NetworkManager.swift
//  TaskMate
//
//  Created by aex on 26.10.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL, noData, decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchTodoResponce(from url: String, with completion: @escaping(Result<TodoResponce, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let todoResponce = try JSONDecoder().decode(TodoResponce.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(todoResponce))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
