//
//  TaskCell.swift
//  TaskMate
//
//  Created by aex on 25.10.2025.
//

import UIKit

class TodoCell: UITableViewCell {
    
    private var todo = UILabel(isBold: true, fontSize: 12, fontColor: .black)
    private var todoDescription = UILabel(isBold: false, fontSize: 10, fontColor: .black)

    
    static let identifier = "TodoCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with todo: Todo) {
        self.todo.text = todo.todo
        self.todoDescription.text = todo.todoDescription
    }
    
    private func setupViews() {
    }
    
    private func setupConstraints() {
        let stack = UIStackView(views: [todo, todoDescription], axis: .vertical, spacing: 2)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}
