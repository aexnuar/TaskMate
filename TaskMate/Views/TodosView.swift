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
    private let todosLabel = UILabel(isBold: false, fontSize: 12, fontColor: .customWhiteForFont, numberOfLines: 1)
    private let addNewTodoButton = UIButton(type: .custom)
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .black
        
        setupTableView()
        setupBottomView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .customGrayForSeparator
        
    }
    
    private func setupBottomView() {
        
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

