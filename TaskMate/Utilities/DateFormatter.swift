//
//  DateFormatter.swift
//  TaskMate
//
//  Created by aex on 27.10.2025.
//

import UIKit

class DateFormatterHelper {
    
    static let shared = DateFormatterHelper()
    
    private let todayDate = Date()
    
    private init() {}
    
    func formatDate(from date: Date?) -> String {
        
        guard let date = date else { return getTodayDate() }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter.string(from: date)
    }
    
    func formatToDate(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter.date(from: string)
    }
    
    func getTodayDate() -> String {
        formatDate(from: todayDate)
    }
}
