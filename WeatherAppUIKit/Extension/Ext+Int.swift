
import Foundation

extension Int {
    // Преобразует из `dateEpoch` в Дату
    func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
    
    // Настройка нужного формата даты
    func toFormattedDateString(format: String = "dd.MM.yyyy HH:mm") -> String {
        let date = self.toDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date).capitalized
    }
    
    // Проверяет текущий ли день
    func isToday() -> Bool {
        let date = self.toDate()
        return Calendar.current.isDateInToday(date)
    }
    
    // Проверяет текущий ли час
    func isCurrentHour() -> Bool {
        let date = self.toDate()
        let currentDate = Date()
        return Calendar.current.isDate(date, equalTo: currentDate, toGranularity: .hour)
    }
}
