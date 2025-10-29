//
//  TaskCell.swift
//  TaskMate
//
//  Created by aex on 25.10.2025.
//

import UIKit

protocol TodoCellDelegate: AnyObject {
    func todoCellDidTapIcon(_ cell: TodoCell)
}

class TodoCell: UITableViewCell {
    
    static let identifier = "TodoCell"
    
    weak var delegate: TodoCellDelegate?
    
    private let todo = UILabel(isBold: true, fontSize: 16)
    private let todoDescription = UILabel(isBold: false, fontSize: 12)
    private let dateLabel = UILabel(isBold: false, fontSize: 12, numberOfLines: 1)
    
    private let iconButton = UIButton(type: .custom)
    
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
            self.todoDescription.text = "Notes"
        }
        
        setupIconButton(isCompleted: todo.completed)
        
        let convertedDate = DateFormatterHelper.shared.formatDate(from: todo.date)
        dateLabel.text = convertedDate
        
        updateLabels(isCompleted: todo.completed)
    }
}

// MARK: - Private methods
extension TodoCell {
    private func setupViews() {
        contentView.backgroundColor = .customBlackForBackground
    }
    
    private func setupConstraints() {
        let stack = UIStackView(views: [todo, todoDescription, dateLabel], axis: .vertical, spacing: 6)
        
        [iconButton, stack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            iconButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconButton.centerYAnchor.constraint(equalTo: todo.centerYAnchor),
            iconButton.widthAnchor.constraint(equalToConstant: 36),
            iconButton.heightAnchor.constraint(equalToConstant: 36),
            
            stack.leadingAnchor.constraint(equalTo: iconButton.trailingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupIconButton(isCompleted: Bool) {
        let imageName = isCompleted ? "checkmark.circle" : "circle"
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .thin)
        
        iconButton.setImage(UIImage(systemName: imageName, withConfiguration: imageConfig), for: .normal)
        iconButton.setImage(UIImage(systemName: imageName, withConfiguration: imageConfig), for: .selected) // check!
        iconButton.tintColor = .customYellowForButton
        
        iconButton.addTarget(self, action: #selector(iconButtonTapped), for: .touchUpInside)
    }
    
    @objc private func iconButtonTapped() {
        delegate?.todoCellDidTapIcon(self)
    }
    
    private func updateLabels(isCompleted: Bool) {
        let views = [todo, todoDescription, dateLabel]
        views.forEach {
            $0.textColor = isCompleted ? .customGrayForSeparator : .customWhiteForFont
        }
    }
}
