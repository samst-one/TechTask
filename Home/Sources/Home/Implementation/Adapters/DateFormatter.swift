import Foundation

protocol DateFormatter {
    func dayMonthYear(date: Date) -> String
    func dayMonthWeekday(date: Date) -> String
    func hourMinute(date: Date) -> String
}

struct DefaultDateFormatter: DateFormatter {
    func dayMonthYear(date: Date) -> String {
        date.formatted(.dateTime.day().month().year())
    }

    func dayMonthWeekday(date: Date) -> String {
        date.formatted(.dateTime.day().month(.wide).weekday(.wide))
    }

    func hourMinute(date: Date) -> String {
        date.formatted(.dateTime.hour().minute())
    }
}
