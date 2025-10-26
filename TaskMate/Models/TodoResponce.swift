//
//  Task.swift
//  TaskMate
//
//  Created by aex on 26.10.2025.
//

import Foundation

struct TodoResponce {
    let todos: [Todo]
    let total, skip, limit: Int
}

struct Todo {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}
