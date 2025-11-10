//
//  TodoDataManager.swift
//  TaskMate
//
//  Created by aex on 26.10.2025.
//

import Foundation

protocol TodoDataUpdateDelegate {
    func onToDoDataUpdate(todos: [Todo], request: String)
}

final class TodoDataManager {
    
    static let shared = TodoDataManager()
    
    private var todos: [Todo] = []
    private var filter: String = ""
    private var dataUpdateDelegates: [TodoDataUpdateDelegate] = []
    
    private var currentTodos: [Todo] {
        filter.isEmpty ? todos : getFilteredTodos(request: filter)
    }
    
    private init() {}
    
    func setTodos(with todos: [Todo]) {
        self.todos = todos
        callDataUpdateDelegates()
    }
    
    func getAllTodos() -> [Todo] {
        todos
    }
    
    func addNewTodo(_ todo: Todo) {
        todos.append(todo)
        callDataUpdateDelegates()
        
        StorageManager.shared.createTodo(todo)
    }
    
    func updateTodo(updatedTodo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == updatedTodo.id }) {
            todos[index] = updatedTodo
        }
        callDataUpdateDelegates()
        StorageManager.shared.updateTodo(updatedTodo)
    }
    
    func deleteTodo(todo: Todo) {
        guard let index = todos.firstIndex(of: todo) else { return }
        todos.remove(at: index)
        // users.contains(where: { $0.id == 2 })
        
        callDataUpdateDelegates()
        StorageManager.shared.deleteTodo(todo)
    }
    
    func getTodo(at index: Int) -> Todo {
        currentTodos[index]
    }
    
    func getTodosCount() -> Int {
        currentTodos.count
    }
    
    func getUncompletedTodosCount() -> Int {
        var uncompletedTodos: [Todo] = []
        
        for todo in todos where todo.completed == false {
            uncompletedTodos.append(todo)
        }
        
        return uncompletedTodos.count
    }
    
    func generateUniqueIntID() -> Int {
        let maxId = todos.map { $0.id }.max() ?? 0
        return maxId + 1
    }
    
    func IfTodosEmpty() -> Bool {
        todos.isEmpty ? true : false
    }
}

// MARK: - Filtares and delegate Todo updates
extension TodoDataManager {
    func setTodosFilter(request: String) {
        filter = request
        callDataUpdateDelegates()
    }
    
    func addDataUpdateDelegate(delegate: TodoDataUpdateDelegate) {
        delegate.onToDoDataUpdate(todos: currentTodos, request: filter)
        dataUpdateDelegates.append(delegate)
    }
    
    func callDataUpdateDelegates() {
        dataUpdateDelegates.forEach {
            $0.onToDoDataUpdate(todos: currentTodos, request: filter)
        }
    }
    
    func getFilteredTodos(request: String) -> [Todo] {
        return todos.filter({
            $0.todo.lowercased().contains(request.lowercased())})
    }
}
