
import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let region : String
    let localtimeEpoch: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case region
        case localtimeEpoch = "localtime_epoch"
    }
}

// MARK: - Current
struct Current: Codable {
    let tempC: Double 
    let condition: Condition
    let windKph : Double
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case windKph = "wind_kph"
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text: String
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let dateEpoch: Int
    let day: Day
    let hour: [Hour]
    
    enum CodingKeys: String, CodingKey {
        case dateEpoch = "date_epoch"
        case day
        case hour
    }
}

// MARK: - Day
struct Day: Codable {
    let avgtempC: Double
    let maxtempC: Double
    let mintempC: Double
    
    enum CodingKeys: String, CodingKey {
        case avgtempC = "avgtemp_c"
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
    }
}

// MARK: - Hour
struct Hour: Codable {
    let timeEpoch: Int
    let tempC: Double
    
    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case tempC = "temp_c"
    }
}

extension Day {
    var formattedTempRange: String {
        "Макс.:\(Int(maxtempC))°, мин.: \(Int(mintempC))°"
    }
}

extension WeatherResponse {
    var currentDay: Forecastday? {
        return forecast.forecastday.first { forecastDay in
            forecastDay.dateEpoch.isToday()
        }
    }
}

extension Hour {
    func formattedTime() -> String {
        if timeEpoch.isCurrentHour() {
            return "Сейчас"
        } else {
            return timeEpoch.toFormattedDateString(format: "HH:mm")
        }
    }
    
    func isCurrentHour() -> Bool {
        return timeEpoch.isCurrentHour()
    }
}

extension Forecastday {
    func formattedDate() -> String {
        if dateEpoch.isToday() {
            return "Сегодня"
        } else {
            return dateEpoch.toFormattedDateString(format: "EEEE")
        }
    }
}



