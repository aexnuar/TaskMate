//
//  DateFormatter.swift
//  TaskMate
//
//  Created by aex on 27.10.2025.
//

import UIKit

class DateFormatterHelper {
    
    static let shared = DateFormatterHelper()
    
    private init() {}
    
    func formatDate(from date: Date?) -> String {
        guard let date = date else { return "Add date" }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        formatter.locale = Locale(identifier: "ru_RU") // check
        
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    
//    func formatDateFromStr(from date: String?) -> String {
//        guard let date = date else { return "Add date" }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd/MM/yy"
//        formatter.locale = Locale(identifier: "ru_RU") // check
//        
//        let dateStr = formatter.string(from: date)
//        return dateStr
//    }
    
//    func formatDateForMainPage(from date: Date?) -> String {
//        guard let date = date else { return "n/a" }
//        
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
//        
//        return formatter.string(from: date)
//    }
}
