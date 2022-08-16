//
//  DateFormatter.swift
//  DoriDori_iOS
//
//  Created by Seori on 2022/08/16.
//

import Foundation

struct DoriDoriDateFormatter {
    private let targetDate: Date?
    private var dateFormatter: DateFormatter?
    
    init(dateString: String) {
        self.dateFormatter = DateFormatter()
        self.dateFormatter?.locale = Locale(identifier: "en_US_POSIX")
        self.dateFormatter?.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        self.targetDate = self.dateFormatter?.date(from: dateString)
    }
    
    init(date: Date) {
        self.targetDate = date
    }
        
    func createdAtText() -> String? {
        guard let targetDate = self.targetDate else { return nil }
        let dateInterval = Calendar.current.dateComponents([.month,.day, .hour, .minute, .second], from: targetDate, to: Date())
        guard let second = dateInterval.second,
              let min = dateInterval.minute,
              let hour = dateInterval.hour,
              let day = dateInterval.day,
              let month = dateInterval.month else { return nil }

        return self.setupCreatedAtText(
            date: targetDate,
            second: second,
            min: min,
            hour: hour,
            day: day,
            month: month
        )
    }
}

// MARK: - Private functions

extension DoriDoriDateFormatter {
    
    private func setupCreatedAtText(date: Date, second: Int, min: Int, hour: Int, day: Int, month: Int) -> String {
        if day != 0 {
            let month = Calendar.current.component(.month, from: date)
            let day = Calendar.current.component(.day, from: date)
            let weekday = Calendar.current.component(.weekday, from: date)
            return "\(month).\(day) \(self.trasnformToKR(weekday))"
        }
        if hour != 0 { return "\(hour)시간 전"}
        if min != 0 { return "\(min)분 전" }
        if second != 0 { return "지금" }
        return ""
    }
    
    private func trasnformToKR(_ weekDay: Int) -> String {
        Weekday(rawValue: weekDay)?.weekdayToKR ?? ""
    }
}

enum Weekday: Int {
    case sunday
    case monday
    case tuesday
    case wednessday
    case thrusday
    case friday
    case saturday
    
    fileprivate var weekdayToKR: String {
        switch self {
        case .sunday: return "일"
        case .monday: return "월"
        case .tuesday: return "화"
        case .wednessday: return "수"
        case .thrusday: return "목"
        case .friday: return "금"
        case .saturday: return "토"
        }
    }
}
