//
//  TodosViewModel.swift
//  TaskMate
//
//  Created by aex on 28.10.2025.
//

//import Foundation

class TodosViewModel {
    
    private let todoDataManager: TodoDataManager
    
    private var todos: [Todo] = []
    private var filter: String = ""
    
    public var count: Int {
        todos.count
    }
    
    var onDataUpdated: (() -> Void)?
    
//    private(set) var allTodos: [Todo] = [] {
//        didSet {
//            onDataUpdated?()
//        }
//    }
    
//    private(set) var filteredTodos: [Todo] = []
    
    init(todoDataManager: TodoDataManager) {
        self.todoDataManager = todoDataManager
        //allTodos = TodoDataManager.shared.getAllTodos()
        
        todoDataManager.addDataUpdateDelegate(delegate: self)
    }
    
    func getTodo(at index: Int) -> Todo {
        todos[index]
    }
}

// MARK: - Search Functions
extension TodosViewModel {
    public func inSearchMode() -> Bool {
//        let isActivate = searchController.isActive
//        let searchText = searchController.searchBar.text ?? ""
//        
//        return isActivate && !searchText.isEmpty
        
        return !filter.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        filter = searchBarText ?? ""
        todoDataManager.setTodosFilter(request: filter)
//        filteredTodos = allTodos
//        
//        if let searchText = searchBarText?.lowercased() {
//            guard !searchText.isEmpty else { onDataUpdated?(); return }
//            
//            filteredTodos = filteredTodos.filter({
//                $0.todo.lowercased().contains(searchText) })
//        }
//        onDataUpdated?()
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

