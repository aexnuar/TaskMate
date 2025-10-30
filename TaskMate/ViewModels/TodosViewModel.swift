//
//  TodosViewModel.swift
//  TaskMate
//
//  Created by aex on 28.10.2025.
//

import UIKit

class TodosViewModel {
    
    var onDataUpdated: (() -> Void)?
    
    private(set) var allTodos: [Todo] = [] {
        didSet {
            onDataUpdated?()
        }
    }
    
    private(set) var filteredTodos: [Todo] = []
    
    init() {
        allTodos = TodoDataManager.shared.getAllTodos()
    }
}

// MARK: - Search Functions
extension TodosViewModel {
    public func inSearchMode(_ searchController: UISearchController) -> Bool {
        let isActivate = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        
        return isActivate && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        filteredTodos = allTodos
        
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { onDataUpdated?(); return }
            
            filteredTodos = filteredTodos.filter({
                $0.todo.lowercased().contains(searchText) })
        }
        
        onDataUpdated?()
    }
}

