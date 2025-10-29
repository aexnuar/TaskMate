//
//  TodosViewModel.swift
//  TaskMate
//
//  Created by aex on 28.10.2025.
//

import UIKit

class TodosViewModel {
    
    var onDataUpdated: (() -> Void)?
    
    private var allTodos: [Todo] = [] {
        didSet {
            onDataUpdated?()
        }
    }
    
    private(set) var filteredTodos: [Todo] = []
    
    private func fetchTodos() {
        allTodos = TodoDataManager.shared.getAllTodos()
    }
}

// MARK: - Search Functions
extension TodosViewModel {
    public func inSearcModel(_ searchController: UISearchController) -> Bool {
        let isActivate = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        
        return isActivate && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        self.filteredTodos = allTodos
    }
}
