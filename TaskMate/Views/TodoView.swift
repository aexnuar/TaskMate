//
//  TodoView.swift
//  TaskMate
//
//  Created by aex on 30.10.2025.
//

import UIKit

class TodoView: UIView {
    
    private let todoTextField = UITextField()
    //private let todoDatePicker = UIDatePicker()
    private let todoDateLabel = UILabel(isBold: false, fontSize: 12)
    private let todoDescriptionTextView = UITextView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .customBlackForBackground
        
        setupSubviews()
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
    
    private func setupSubviews() {
        todoTextField.placeholder = "Todo"
        todoTextField.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        todoTextField.textColor = .customWhiteForFont
        
        todoDescriptionTextView.font = UIFont.systemFont(ofSize: 16)
        todoDescriptionTextView.textColor = .customWhiteForFont
        todoDescriptionTextView.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        let stackSubviews = UIStackView(
            views: [todoTextField, todoDateLabel, todoDescriptionTextView],
            axis: .vertical,
            spacing: 8
        )
        
        stackSubviews.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackSubviews)
        
        NSLayoutConstraint.activate([
            todoTextField.heightAnchor.constraint(equalToConstant: 44),
            todoDescriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            
            stackSubviews.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            stackSubviews.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackSubviews.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
}
