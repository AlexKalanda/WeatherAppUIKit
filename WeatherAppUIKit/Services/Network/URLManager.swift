
import Foundation

final class URLManager {
    static let shared = URLManager(); private init() { }
    
    private enum Constants {
        static let scheme = "https"
        static let host = "api.weatherapi.com"
        static let path = "/v1/forecast.json"
        static let apiKey = "a58ae29d584b4609a29154822251905"
    }
    
    func createCurrentURL(latitude: Double, longitude: Double) throws -> URL {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.path
        
        components.queryItems = [
            URLQueryItem(name: "key", value: Constants.apiKey),
            URLQueryItem(name: "q", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "days", value: "7"),
            URLQueryItem(name: "aqi", value: "no"),
            URLQueryItem(name: "alerts", value: "no"),
            URLQueryItem(name: "lang", value: "ru")
        ]
        
        guard let url = components.url else {
            throw HTTPError.invalidURL
        }
        
        return url
    }
}
