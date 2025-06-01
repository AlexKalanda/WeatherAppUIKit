
import Foundation

extension HomeViewController {
    // Вычисляемое свойство для хранения данных по часам на текущий день и следующий 
    var hourlyForecast: [Hour] {
        guard let weather = weather else { return [] }
        
        let currentDate = Date()
        let currentHour = Calendar.current.component(.hour, from: currentDate)
        
        var allHours = [Hour]()
        
        if let todayHours = weather.forecast.forecastday.first?.hour {
            let remainingTodayHours = Array(todayHours.dropFirst(currentHour))
            allHours.append(contentsOf: remainingTodayHours)
        }
        
        if weather.forecast.forecastday.count > 1 {
            allHours.append(contentsOf: weather.forecast.forecastday[1].hour)
        }
        
        return allHours
    }
}
