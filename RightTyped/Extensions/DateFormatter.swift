//
//  DateFormatter.swift
//  RightTyped
//
//  Created by Vitandrea Sorino on 24/09/23.
//

import Foundation

extension DateFormatter{
    static func getLocalDateFormatter() -> String{
        #if DEBUG
        let userFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd hhmmss", options: 0, locale: Locale.current)
        #elseif RELEASE
        let userFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
        #endif
        guard let userFormat = userFormat else {
            return "MM/dd/yyyy"
        }
        return userFormat
    }
    
    static func getFormatted(_ myDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = getLocalDateFormatter()
        return dateFormatter.string(from: myDate)
    }
}
