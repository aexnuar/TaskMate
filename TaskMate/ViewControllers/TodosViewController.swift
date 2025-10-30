//
//  TaskListViewController.swift
//  TaskMate
//
//  Created by aex on 25.10.2025.
//

import UIKit

class TodosViewController: UIViewController {
    
    private lazy var mainView = TodosView()
    private let viewModel = TodosViewModel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTodos(from: Link.todoResponce.rawValue)
        setupNavigationBar()
        setupSearchController()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension TodosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TodoDataManager.shared.getTodosCount()
        
//        let inSearchMode = viewModel.inSearchMode(searchController)
//        return inSearchMode ? viewModel.filteredTodos.count : viewModel.allTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else { return UITableViewCell() }
        
        let todo = TodoDataManager.shared.getTodo(at: indexPath)
        cell.configure(with: todo, delegate: self, index: indexPath)
        
//        let inSearchMode = viewModel.inSearchMode(searchController)
//        let todo = inSearchMode ? viewModel.filteredTodos[indexPath.row] : viewModel.allTodos[indexPath.row]
//        cell.configure(with: todo, delegate: self, index: indexPath)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        106
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainView.tableView.deselectRow(at: indexPath, animated: true)
        
        let todo = TodoDataManager.shared.getTodo(at: indexPath)
        let todoVC = TodoViewController(todo: todo)
        navigationController?.pushViewController(todoVC, animated: true)
    }
}

// MARK: - Private methods
extension TodosViewController {
    private func fetchTodos(from url: String) {
        NetworkManager.shared.fetchTodoResponce(from: url) { result in
            switch result {
            case .success(let todoResponce):
                TodoDataManager.shared.setTodos(with: todoResponce.todos)
                self.mainView.tableView.reloadData()
                self.setupViews()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupNavigationBar() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always // check!
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .customBlackForBackground
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.customWhiteForFont]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.customWhiteForFont]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    private func setupViews() {
        let todosCount = TodoDataManager.shared.getTodosCount()
        let todoWord = DataFormatter.shared.formatTodoWord(for: todosCount)
        mainView.configureTodosLabel(with: todosCount, and: todoWord)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        navigationItem.searchController = searchController
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}

// MARK: - Search Controller Functions
extension TodosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
}

// MARK: - TodoCellDelegate
extension TodosViewController: TodoCellDelegate {
    func toogleToDoCompleted(for todo: Todo, at index: IndexPath) {
        var todo = todo
        todo.completed.toggle()
        TodoDataManager.shared.updateTodo(updatedTodo: todo)
        
        mainView.tableView.reloadRows(at: [index], with: .automatic)
    }
}
