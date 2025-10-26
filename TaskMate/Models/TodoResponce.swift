//
//  Task.swift
//  TaskMate
//
//  Created by aex on 26.10.2025.
//

import Foundation

struct TodoResponce: Codable {
    let todos: [Todo]
    let total, skip, limit: Int
}

struct Todo: Codable {
    let id: Int
    let todo: String
    let todoDescription: String?
    let completed: Bool
    let userID: Int
    let date: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, todo, todoDescription, completed, date
        case userID = "userId"
    }
}
