//
//  TodoViewController.swift
//  TaskMate
//
//  Created by aex on 30.10.2025.
//

import UIKit

class TodoViewController: UIViewController {
    
    private var todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func loadView() {
//        
//    }
    
    override func viewDidLoad() {
        print(todo)
    }
}
