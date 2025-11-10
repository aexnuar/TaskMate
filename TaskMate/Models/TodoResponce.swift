//
//  Task.swift
//  TaskMate
//
//  Created by aex on 26.10.2025.
//

import Foundation

struct TodoResponce: Decodable, Equatable {
    let todos: [Todo]
    let total, skip, limit: Int
}

struct Todo: Decodable, Equatable {
    let id: Int
    var todo: String
    var todoDescription: String?
    var completed: Bool
    let userID: Int
    var date: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, todo, todoDescription, completed, date
        case userID = "userId"
    }
}
