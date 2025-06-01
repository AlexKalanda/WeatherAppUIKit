
import Foundation

final class ParsingService {
    static let shared = ParsingService()
    private init() {}
    private let decoder = JSONDecoder()
    
    func getWeather(fromData data: Data) throws -> WeatherResponse {
        return try decoder.decode(WeatherResponse.self, from: data)
    }
}
