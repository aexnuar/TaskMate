//
//  TaskListViewController.swift
//  TaskMate
//
//  Created by aex on 25.10.2025.
//

import UIKit

class TodosViewController: UIViewController {
    
    private lazy var mainView = TodosView()
    private let viewModel: TodosViewModel
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        
        fetchTodosFromCoreData()
        
        if TodoDataManager.shared.IfTodosEmpty() {
            fetchTodos(from: Link.todoResponce.rawValue)
        }
        
        setupNavigationBar()
        setupSearchController()
        setupActions()
        
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.mainView.tableView.reloadData()
                self?.setupViews()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    init(viewModel: TodosViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDataSource
extension TodosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else { return UITableViewCell() }
        
        let todo = viewModel.getTodo(at: indexPath.row)
        cell.configure(todo: todo, delegate: self, index: indexPath)
        
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
        let todoVC = TodoViewController(todo: todo, index: indexPath)
        //todoVC.delegate = self
        navigationController?.pushViewController(todoVC, animated: true)
        
        navigationItem.backButtonTitle = "Назад"
        
        //TodoDataManager.shared.deleteTodo(todo: todo)
    }
}

// MARK: - Private methods
extension TodosViewController {
    private func fetchTodos(from url: String) {
        NetworkManager.shared.fetchTodoResponce(from: url) { result in
            switch result {
            case .success(let todoResponce):
                TodoDataManager.shared.setTodos(with: todoResponce.todos)
                
                todoResponce.todos.forEach {
                    StorageManager.shared.createTodo($0)
                }
                
                print("\(todoResponce.todos.count) todos downloaded from neetwork")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchTodosFromCoreData() {
        StorageManager.shared.fetchTodos { result in
            switch result {
            case .success(let todos):
                TodoDataManager.shared.setTodos(with: todos)
                self.setupViews()
                print("\(todos.count) todos downloaded from core data")
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
        let todosCount = TodoDataManager.shared.getUncompletedTodosCount()
        let todoWord = DataFormatter.shared.formatTodoWord(for: todosCount)
        mainView.configureTodosLabel(with: todosCount, and: todoWord)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        definesPresentationContext = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.searchTextField.textColor = .customWhiteForFont
        let placeholderText = "Search"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.4)
        ]
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        if let glassIconView = searchController.searchBar.searchTextField.leftView as? UIImageView {
            glassIconView.tintColor = UIColor.white.withAlphaComponent(0.4)
        }
    }
    
    private func setupActions() {
        mainView.addTargetForAddNewTodoButton(target: self, action: #selector(addNewTodoButtonTapped))
    }
    
    @objc private func addNewTodoButtonTapped() {
        showTodoPage()
    }
    
    private func showTodoPage() {
        let todoVC = TodoViewController(todo: nil, index: nil)
        //todoVC.delegate = self
        
        navigationController?.pushViewController(todoVC, animated: true)
        navigationItem.backButtonTitle = "Назад"
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

// MARK: - TodoViewUpdateDelegate
//extension TodosViewController: TodoViewUpdateDelegate {
//    func todoViewDidRequestReload(at index: IndexPath) {
//        mainView.tableView.reloadRows(at: [index], with: .automatic)
//    }
//}
