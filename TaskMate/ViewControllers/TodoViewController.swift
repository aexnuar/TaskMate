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
        super.viewDidLoad()
        
        mainView.setDescriptionTextViewDelegate(self)
        
        setupNavigationBar()
        setupViews()
        setupActions()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let newTitle = mainView.getTitle().trimmingCharacters(in: .whitespacesAndNewlines)
        let newDescription = mainView.getDescription().trimmingCharacters(in: .whitespacesAndNewlines)
        let newDate = mainView.getDate()
        let defaultDescription = "Notes"
        
        guard !newTitle.isEmpty || !newDescription.isEmpty && newDescription != defaultDescription else {
            return
        }
        
        if todo == nil {
            createNewTodo(title: newTitle, description: newDescription == defaultDescription ? "" : newDescription, date: newDate)
        } else {
            updateExistingTodo(title: newTitle, description: newDescription == defaultDescription ? "" : newDescription, date: newDate)
        }
    }
}

// MARK: - Private methods
extension TodoViewController {
    private func createNewTodo(title: String, description: String, date: Date) {
        let newId = TodoDataManager.shared.generateUniqueIntID()
        let newTodo = Todo(
            id: newId,
            todo: title,
            todoDescription: description,
            completed: false,
            userID: 0,
            date: date
        )
        TodoDataManager.shared.addNewTodo(newTodo)
    }
    
    private func updateExistingTodo(title: String, description: String, date: Date) {
        guard var todo = todo else { return }
        
        if todo.todo != title || todo.todoDescription != description {
            todo.todo = title
            todo.todoDescription = description
            todo.date = date
            TodoDataManager.shared.updateTodo(updatedTodo: todo)
        }
    }
    
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
        
        if mainView.getDescription().trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            mainView.showDescriptionText()
        }
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension TodoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Notes" {
            mainView.clearDescriptionText()
        }
    }
}
