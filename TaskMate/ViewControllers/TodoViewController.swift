//
//  TodoViewController.swift
//  TaskMate
//
//  Created by aex on 30.10.2025.
//

import UIKit

class TodoViewController: UIViewController {
    
    private lazy var mainView = TodoView()
    private var todo: Todo?
    
    init(todo: Todo?) {
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        setupNavigationBar()
        setupViews()
        setupActions()
    }
}

// MARK: - Private methods
extension TodoViewController {
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .customYellowForButton
    }
    
    private func setupViews() {
        guard let todo = todo else {
            mainView.configure(title: "", dateStr: "Date", description: "Note")
            return
        }
        
        let dateStr = DateFormatterHelper.shared.formatDate(from: todo.date)
        mainView.configure(title: todo.todo, dateStr: dateStr, description: todo.todoDescription ?? "Note")
        
//        if let todo = todo {
//            let dateStr = DateFormatterHelper.shared.formatDate(from: todo.date)
//            
//            mainView.configure(title: todo.todo, dateStr: dateStr, description: todo.todoDescription ?? "Note")
//        } else {
//            mainView.configure(title: "", dateStr: "Date", description: "Note")
//        }
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
