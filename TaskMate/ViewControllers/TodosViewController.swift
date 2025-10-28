//
//  TaskListViewController.swift
//  TaskMate
//
//  Created by aex on 25.10.2025.
//

import UIKit

class TodosViewController: UIViewController {
    
    private lazy var mainView = TodosView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTodos(from: Link.todoResponce.rawValue)
        setupNavigationBar()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension TodosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TodoDataManager.shared.getTodosCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else { return UITableViewCell() }
        
        let todo = TodoDataManager.shared.getTodo(at: indexPath)
        cell.configure(with: todo)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TodosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        106
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
}
