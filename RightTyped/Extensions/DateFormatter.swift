//
//  DateFormatter.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/09/23.
//

import Foundation

extension DateFormatter{
    static func getLocalDateFormatter() -> String{
        let userFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
        if let userFormat = userFormat{
            return userFormat
        }else{
            return "MM/dd/yyyy"
        }
    }
    
    static func getFormatted(_ myDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = getLocalDateFormatter()
        return dateFormatter.string(from: myDate)
    }
}
