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
    private var completedTodos: [Todo] = []
    
    private init() {}
    
    func setTodos(with todos: [Todo]) {
        self.todos = todos
    }
    
    func getAllTodos() -> [Todo] {
        todos
    }
    
    func updateTodo(updatedTodo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == updatedTodo.id }) {
            todos[index] = updatedTodo
        }
    }
    
    func getTodo(at indexPath: IndexPath) -> Todo {
        todos[indexPath.row]
    }
    
    func getTodosCount() -> Int {
        todos.count
    }
}
