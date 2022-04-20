//
//  Date.swift
//  BirthdayBotManagerApp
//
//  Created by Christopher Elbert on 1/21/22.
//

import Foundation

extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "MM-dd-yyyy"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
    
    //https://stackoverflow.com/questions/40075850/swift-3-find-number-of-calendar-days-between-two-dates
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
    
    func asAbbreviatedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
    }
    
    static func daysUntilNextOccurance(targetDate: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        var dateComponents = DateComponents()
        
        
        let targetDay = calendar.component(.day, from: targetDate)
        let targetMonth = calendar.component(.month, from: targetDate)
        
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        let targetYear = currentMonth > targetMonth ? currentYear : currentYear + 1
        
        dateComponents.day = targetDay
        dateComponents.month = targetMonth
        dateComponents.year = targetYear
        
        guard var nextOccuranceDate = calendar.date(from: dateComponents) else {
            return -1
        }
        
        // strip time
        nextOccuranceDate = calendar.startOfDay(for: nextOccuranceDate)
        let daysUntilBirthday = nextOccuranceDate.interval(ofComponent: .day, fromDate: currentDate)
        
        // leap year
        if currentYear % 4 == 0 || currentYear % 400 == 0 {
            return daysUntilBirthday == 366 ? 0 : daysUntilBirthday
        }
        
        return daysUntilBirthday == 365 ? 0 : daysUntilBirthday
    }
    
}
