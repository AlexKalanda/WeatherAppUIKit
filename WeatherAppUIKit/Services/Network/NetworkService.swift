
import Foundation

final class NetworkService {
    static let shared = NetworkService()
    private init() {}
    private let session = URLSession.shared
 
    func getWeather(latitude: Double, longitude: Double,
                   completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        do {
            let url = try URLManager.shared.createCurrentURL(
                latitude: latitude,
                longitude: longitude
            )
            
            session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(HTTPError.badResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(HTTPError.badRequest))
                    return
                }
                
                do {
                    let weather = try ParsingService.shared.getWeather(fromData: data)
                    completion(.success(weather))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
            
        } catch {
            completion(.failure(error))
        }
    }
}
