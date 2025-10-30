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

class TodoDataManager {
    
    static let shared = TodoDataManager()
    
    private var todos: [Todo] = []
    private var completedTodos: [Todo] = []
    
    private var filter: String = ""
    
    private var dataUpdateDelegates: [TodoDataUpdateDelegate] = []
    
    private init() {}
    
    func setTodos(with todos: [Todo]) {
        self.todos = todos
        
        callDataUpdateDelegates()
    }
    
    func getAllTodos() -> [Todo] {
        todos
    }
    
    func updateTodo(updatedTodo: Todo) {
        if let index = todos.firstIndex(where: { $0.id == updatedTodo.id }) {
            todos[index] = updatedTodo
        }
        
        callDataUpdateDelegates()
    }
    
    func getTodo(at indexPath: IndexPath) -> Todo {
        todos[indexPath.row]
    }
    
    func getTodosCount() -> Int {
        todos.count
    }
}

// MARK: - Filtares and delegate TODO updates
extension TodoDataManager {
    func setTodosFilter(request: String) {
        filter = request
        
        callDataUpdateDelegates()
    }
    
    func addDataUpdateDelegate(delegate: TodoDataUpdateDelegate) {
        //        if !dataUpdateDelegates.contains(where: { element in
        //            dataUpdateDelegates.append(element)
        //        })
        delegate.onToDoDataUpdate(todos: filter.isEmpty ? todos : getFilteredTodos(request: filter), request: filter)
        
        dataUpdateDelegates.append(delegate)
    }
    
    func callDataUpdateDelegates() {
        dataUpdateDelegates.forEach {
            $0.onToDoDataUpdate(todos: filter.isEmpty ? todos : getFilteredTodos(request: filter), request: filter)
        }
    }
    
    func getFilteredTodos(request: String) -> [Todo] {
        return todos.filter({
            $0.todo.lowercased().contains(request.lowercased())})
    }
}
