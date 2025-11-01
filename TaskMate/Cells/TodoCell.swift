//
//  TaskCell.swift
//  TaskMate
//
//  Created by aex on 25.10.2025.
//

import UIKit

protocol TodoCellDelegate: AnyObject {
    func toogleToDoCompleted(for todo: Todo, at index: IndexPath)
}

class TodoCell: UITableViewCell {
    
    static let identifier = "TodoCell"
    
    private var action: UIAction?
    
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
    
    func configure(todo: Todo, delegate: TodoCellDelegate, index: IndexPath) {
        configureLables(with: todo)
        configureActionForIconButton(with: todo, delegate, index)
        
        setupIconButton(isCompleted: todo.completed)
        setupLabelsColor(isCompleted: todo.completed)
        setupStrikethrough(for: todo)
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
}

// MARK: - Configure methods
extension TodoCell {
    private func configureActionForIconButton(with todo: Todo, _ delegate: TodoCellDelegate, _ index: IndexPath) {
        if let action = action {
            iconButton.removeAction(action, for: .touchUpInside)
        }
        
        action = UIAction { [weak delegate] _ in
            delegate?.toogleToDoCompleted(for: todo, at: index)
        }
        
        //        action = UIAction { [weak delegate, weak self] _ in
        //            if let self = self {
        //                let superview = self.superview as? UITableView
        //                guard let index = superview?.indexPath(for: self) else { return }
        //                delegate?.toogleToDoCompleted(for: todo, at: index)
        //            }
        //        }
        
        guard let action = action else { return }
        iconButton.addAction(action, for: .touchUpInside)
    }
    
    private func configureLables(with todo: Todo) {
        if let description = todo.todoDescription, let date = todo.date {
            todoDescription.text = description
            dateLabel.text = DateFormatterHelper.shared.formatDate(from: date)
            todoDescription.isHidden = false
            dateLabel.isHidden = false 
        } else {
            todoDescription.isHidden = true
            dateLabel.isHidden = true
        }
    }
    
    private func setupIconButton(isCompleted: Bool) {
        let imageName = isCompleted ? "checkmark.circle" : "circle"
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .thin)
        
        iconButton.setImage(UIImage(systemName: imageName, withConfiguration: imageConfig), for: .normal)
        iconButton.setImage(UIImage(systemName: imageName, withConfiguration: imageConfig), for: .selected) // check!
        iconButton.tintColor = .customYellowForButton
    }
    
    private func setupLabelsColor(isCompleted: Bool) {
        let labels = [todo, todoDescription, dateLabel]
        labels.forEach {
            $0.textColor = isCompleted ? .customGray : .customWhiteForFont
        }
    }
    
    private func setupStrikethrough(for todo: Todo) {
        self.todo.attributedText = nil
        
        if todo.completed {
            let attributeString = NSMutableAttributedString(string: todo.todo)
            attributeString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: attributeString.length)
            )
            self.todo.attributedText = attributeString
        } else {
            self.todo.text = todo.todo
        }
    }
}




