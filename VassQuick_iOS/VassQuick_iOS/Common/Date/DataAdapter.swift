//
//  DataAdapter.swift
//  VassQuick_iOS
//
//  Created by Markel Juaristi Mendarozketa   on 22/3/24.
//

import Foundation

extension Date {
    // Formatea la fecha a "día/mes/año".
    static func formatDate(from isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = formatter.date(from: isoDate) else { return "" }
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }

    // Formatea la hora a "hora:minuto:segundo".
    static func formatTime(from isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = formatter.date(from: isoDate) else { return "" }
        formatter.dateFormat = "HH:mm:ss"
        return formatter.string(from: date)
    }
    
    // Formatea la hora a "hora:minuto:segundo".
    static func formatTimeChat(from isoDate: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = formatter.date(from: isoDate) else { return "" }
        formatter.dateFormat = "dd-MM / HH:mm"
        return formatter.string(from: date)
    }
}
