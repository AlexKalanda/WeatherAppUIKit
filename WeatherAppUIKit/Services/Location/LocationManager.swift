
import CoreLocation

final class LocationManager: NSObject {
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    private var completion: ((CLLocationCoordinate2D?) -> Void)?
    private override init() {
        super.init()
        manager.delegate = self
    }
    
        func getLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
               self.completion = completion
               switch manager.authorizationStatus {
               case .notDetermined:
                   manager.requestWhenInUseAuthorization() // Запрашиваем разрешение
               case .authorizedWhenInUse, .authorizedAlways:
                   manager.startUpdatingLocation() // Уже есть доступ – запускаем GPS
               case .denied, .restricted:
                   completion(nil) // Доступ запрещен
               @unknown default:
                   completion(nil)
               }
           }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        manager.stopUpdatingLocation()
        completion?(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
           switch manager.authorizationStatus {
           case .authorizedWhenInUse, .authorizedAlways:
               manager.startUpdatingLocation()
           case .denied, .restricted:
               completion?(nil)
           default:
               break
           }
       }
}
