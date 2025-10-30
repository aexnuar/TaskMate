//
//  TaskListView.swift
//  TaskMate
//
//  Created by aex on 25.10.2025.
//

import UIKit

class TodosView: UIView {
    
    let tableView = UITableView()
    
    private let bottomView = UIView()
    private let todosLabel = UILabel(isBold: false, fontSize: 11, fontColor: .customWhiteForFont, numberOfLines: 1)
    private let addNewTodoButton = UIButton(type: .custom)
    
    init() {
        super.init(frame: .zero)
        //backgroundColor = .black
        
        setupTableView()
        setupBottomView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTodosLabel(with todosCount: Int, and word: String) {
        todosLabel.text = "\(todosCount) \(word)"
    }
    
    private func setupTableView() {
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .customGrayForSeparator
        
        tableView.backgroundColor = .customBlackForBackground
        
    }
    
    private func setupBottomView() {
        bottomView.backgroundColor = .customGrayForSearch

        let imageName = "square.and.pencil"
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        
        addNewTodoButton.setImage(UIImage(systemName: imageName, withConfiguration: imageConfig), for: .normal)
        addNewTodoButton.tintColor = .customYellowForButton
    }
    
    private func setupConstraints() {
        let views = [
            tableView, bottomView,
            todosLabel, addNewTodoButton
        ]
        
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(tableView)
        addSubview(bottomView)
        bottomView.addSubview(todosLabel)
        bottomView.addSubview(addNewTodoButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 90),
            
            todosLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 24),
            todosLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            
            addNewTodoButton.centerYAnchor.constraint(equalTo: todosLabel.centerYAnchor),
            addNewTodoButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -22)
        ])
    }
}

