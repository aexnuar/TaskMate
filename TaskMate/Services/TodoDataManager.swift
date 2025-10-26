//
//  TodoDataManager.swift
//  TaskMate
//
//  Created by aex on 26.10.2025.
//

import Foundation

class TodoDataManager {
    
    static let shared = TodoDataManager()
    
    private var todos: [Todo] = []
    
    private init() {}
    
    func getTodo(at indexPath: IndexPath) -> Todo {
        todos[indexPath.row]
    }
    
    func getTodosCount() -> Int {
        todos.count
    }
}
