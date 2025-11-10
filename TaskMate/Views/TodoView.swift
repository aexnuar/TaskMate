//
//  TodoView.swift
//  TaskMate
//
//  Created by aex on 30.10.2025.
//

import UIKit

final class TodoView: UIView {
    
    private let todoTextField = UITextField()
    private let todoDateLabel = UILabel(isBold: false, fontSize: 12)
    private let todoDescriptionTextView = UITextView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .customBlackForBackground
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, dateStr: String, description: String) {
        todoTextField.text = title
        todoDescriptionTextView.text = description
        todoDateLabel.text = dateStr
    }
    
    private func setupViews() {
        todoTextField.placeholder = "Todo"
        todoTextField.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        todoTextField.textColor = .customWhiteForFont
        todoTextField.keyboardAppearance = .dark
        
        todoDescriptionTextView.font = UIFont.systemFont(ofSize: 16)
        todoDescriptionTextView.textColor = .customWhiteForFont
        todoDescriptionTextView.keyboardAppearance = .dark
        todoDescriptionTextView.backgroundColor = .clear
        todoDescriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        todoDescriptionTextView.textContainer.lineFragmentPadding = 0
    }
    
    private func setupConstraints() {
        let subViews = [todoTextField, todoDateLabel, todoDescriptionTextView]
        
        subViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            todoTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            todoTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            todoTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            todoTextField.heightAnchor.constraint(equalToConstant: 41),
            
            todoDateLabel.topAnchor.constraint(equalTo: todoTextField.bottomAnchor, constant: 8),
            todoDateLabel.leadingAnchor.constraint(equalTo: todoTextField.leadingAnchor),
            todoDateLabel.trailingAnchor.constraint(equalTo: todoTextField.trailingAnchor),
            
            todoDescriptionTextView.topAnchor.constraint(equalTo: todoDateLabel.bottomAnchor, constant: 8),
            todoDescriptionTextView.leadingAnchor.constraint(equalTo: todoTextField.leadingAnchor),
            todoDescriptionTextView.trailingAnchor.constraint(equalTo: todoTextField.trailingAnchor),
            todoDescriptionTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.3)
        ])
    }
}

// MARK: - TodoView methods
extension TodoView {
    func getTitle() -> String {
        todoTextField.text ?? ""
    }
    
    func getDate() -> Date {
        let dateString = todoDateLabel.text ?? ""
        return DateFormatterHelper.shared.formatToDate(from: dateString) ?? Date()
    }
    
    func getDescription() -> String {
        todoDescriptionTextView.text ?? ""
    }
}

// MARK: - TextView methods
extension TodoView {
    func clearDescriptionText() {
        todoDescriptionTextView.text = ""
    }
    
    func showDescriptionText() {
        todoDescriptionTextView.text = "Notes"
    }
    
    func setDescriptionTextViewDelegate(_ delegate: UITextViewDelegate) {
        todoDescriptionTextView.delegate = delegate
    }
}


