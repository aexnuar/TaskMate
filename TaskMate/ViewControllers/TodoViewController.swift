//
//  TodoViewController.swift
//  TaskMate
//
//  Created by aex on 30.10.2025.
//

import UIKit

//protocol TodoViewUpdateDelegate: AnyObject {
//    func todoViewDidRequestReload(at index: IndexPath)
//}

class TodoViewController: UIViewController {
    
    private lazy var mainView = TodoView()
    private var todo: Todo?
    private var index: IndexPath?
    
//    weak var delegate: TodoViewUpdateDelegate?
    
    init(todo: Todo?, index: IndexPath?) {
        self.todo = todo
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        setupActions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        guard var todo = todo, var index = index else {
            let newId = TodoDataManager.shared.generateUniqueIntID()
            let newTodo = Todo(
                id: newId,
                todo: mainView.getTitle(),
                todoDescription: mainView.getDescription(),
                completed: false,
                userID: 0,
                date: mainView.getDate()
            )

            TodoDataManager.shared.addNewTodo(newTodo)
            return
        }
        
        todo.todo = mainView.getTitle()
        todo.date = mainView.getDate()
        todo.todoDescription = mainView.getDescription()
        
        TodoDataManager.shared.updateTodo(updatedTodo: todo)
    }
}

// MARK: - Private methods
extension TodoViewController {
//    private func getTodo() -> Todo {
//        let todo: Todo
//    
//    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .customYellowForButton
    }
    
    private func setupViews() {
        let today = Date()
        let todayDate = DateFormatterHelper.shared.formatDate(from: today)
        
        guard let todo = todo else {
            mainView.configure(title: "", dateStr: todayDate, description: "Notes")
            return
        }
        
        let dateStr = DateFormatterHelper.shared.formatDate(from: todo.date)
        mainView.configure(title: todo.todo, dateStr: dateStr, description: todo.todoDescription ?? "Notes")
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
