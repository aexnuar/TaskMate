//
//  TaskCell.swift
//  TaskMate
//
//  Created by aex on 25.10.2025.
//

import UIKit

class TodoCell: UITableViewCell {
    
    static let identifier = "TodoCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with todo: Todo) {
        
    }
    
    private func setupViews() {
    }
    
    private func setupConstraints() {
    }
    
}
