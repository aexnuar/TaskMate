//
//  TodosViewModel.swift
//  TaskMate
//
//  Created by aex on 28.10.2025.
//

final class TodosViewModel {

    var onDataUpdated: (() -> Void)?
    
    private let todoDataManager: TodoDataManager
    private var todos: [Todo] = []
    private var filter: String = ""
    
    public var count: Int {
        todos.count
    }
    
    init(todoDataManager: TodoDataManager) {
        self.todoDataManager = todoDataManager
        todoDataManager.addDataUpdateDelegate(delegate: self)
    }
    
    func getTodo(at index: Int) -> Todo {
        todos[index]
    }
}

// MARK: - Search Functions
extension TodosViewModel {
    public func inSearchMode() -> Bool {
        !filter.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        filter = searchBarText ?? ""
        todoDataManager.setTodosFilter(request: filter)
    }
}

// MARK: - TodoDataUpdateDelegate
extension TodosViewModel: TodoDataUpdateDelegate {
    func onToDoDataUpdate(todos: [Todo], request: String) {
        self.todos = todos
        filter = request
        onDataUpdated?()
    }
}

