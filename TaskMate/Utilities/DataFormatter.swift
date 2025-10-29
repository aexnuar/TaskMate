//
//  DataFormatter.swift
//  TaskMate
//
//  Created by aex on 28.10.2025.
//

import Foundation

class DataFormatter {
    
    static let shared = DataFormatter()
    
    private init() {}
    
    func formatTodoWord(for count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "Задача"
        } else if (2...4).contains(remainder10) && !(12...14).contains(remainder100) {
            return "Задачи"
        } else {
            return "Задач"
        }
    }    
}

