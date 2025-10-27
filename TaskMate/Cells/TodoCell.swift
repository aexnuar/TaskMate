//
//  TaskCell.swift
//  TaskMate
//
//  Created by aex on 25.10.2025.
//

import UIKit

class TodoCell: UITableViewCell {
    
    private var todo = UILabel(isBold: true, fontSize: 16)
    private var todoDescription = UILabel(isBold: false, fontSize: 10)
    
    static let identifier = "TodoCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with todo: Todo) {
        self.todo.text = todo.todo
        if todo.todoDescription != nil {
            self.todoDescription.text = todo.todoDescription
        } else {
            self.todoDescription.text = "Заметки"
        }
    }
    
    private func setupViews() {
        contentView.backgroundColor = .customBackgroundBlack
    }
    
    private func setupConstraints() {
        let stack = UIStackView(views: [todo, todoDescription], axis: .vertical, spacing: 6)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
