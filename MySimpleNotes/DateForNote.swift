//
//  DateForNote.swift
//  MySimpleNotes
//
//  Created by Eric Grant on 30.09.2021.
//

import Foundation

class DateForNote {
    
    static func convertDate(date: Date) -> String {
        
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.doesRelativeDateFormatting = true
        relativeDateFormatter.dateStyle = .long
        relativeDateFormatter.timeStyle = .medium
        
        let absoluteDateFormatter = DateFormatter()
        absoluteDateFormatter.dateStyle = .long
        absoluteDateFormatter.timeStyle = .medium
        
        let relative = relativeDateFormatter.string(from: date)
        let absolute = absoluteDateFormatter.string(from: date)
        
        if (relative == absolute) {
            let prefedDateFormatter = DateFormatter()
            prefedDateFormatter.setLocalizedDateFormatFromTemplate("dd-MMM-yyyy H:mm aa")
            return prefedDateFormatter.string(from: date)
        } else {
            return relative
        }
    }
}

extension Date {
    func toMinutes() -> Int64! {
        return Int64((self.timeIntervalSince1970).rounded())
    }
    
    init(minutes:Int64!) {
        self = Date(timeIntervalSince1970: TimeInterval(Double.init(minutes)))
    }
}
