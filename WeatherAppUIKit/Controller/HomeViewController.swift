
import UIKit
import CoreLocation

final class HomeViewController: UIViewController {
    // MARK: - Свойства
    private let defaultCoordinate = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173) // Москва
    private let mainView = HomeView()
    private let locationManager = LocationManager.shared
    private let networkService = NetworkService.shared
    var weather: WeatherResponse? {
        didSet {
            if let weather = weather {
                configuration(with: weather)
                mainView.colletionView.reloadData()
            }
        }
    }
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        mainView.alpha = 0
        setupCollectionView()
        requestLocationAndWeather()
    }
    // Настройка коллекции
    private func setupCollectionView() {
        mainView.colletionView.delegate = self
        mainView.colletionView.dataSource = self
    }
    // Запрос на доступ к геопозиции
    private func requestLocationAndWeather() {
        locationManager.getLocation { [weak self] coordinate in
            guard let self = self else { return }
            
            let targetCoordinate = coordinate ?? self.defaultCoordinate
            self.fetchWeather(for: targetCoordinate)
        }
    }
    // Получение данных о погоде
    private func fetchWeather(for coordinate: CLLocationCoordinate2D) {
        networkService.getWeather(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weather):
                    self?.handleWeatherSuccess(weather)
                case .failure(let error):
                    self?.handleWeatherError(error)
                }
            }
        }
    }
    // В случае успешного получения данных
    private func handleWeatherSuccess(_ weather: WeatherResponse) {
        self.weather = weather
        UIView.animate(withDuration: 0.2) {
            self.mainView.alpha = 1
        }
    }
    // В случае ошибки получения данных
    private func handleWeatherError(_ error: Error) {
        showErrorAlert(error: error)
    }
    // Показываем алерт с ошибкой
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(
            title: "Повторить",
            style: .default
        ) { [weak self] _ in
            self?.requestLocationAndWeather()
        }
        
        alert.addAction(retryAction)
        present(alert, animated: true)
    }
    // Конфигурация
    private func configuration(with weather: WeatherResponse) {
        mainView.cityLbl.text = weather.location.name
        mainView.currentTemp.text = "\(Int(weather.current.tempC))°"
        mainView.descriptionWeather.text = weather.current.condition.text
        mainView.maxminTemp.text = weather.currentDay?.day.formattedTempRange ?? "Нет данных"
    }
    
}

extension HomeViewController: UICollectionViewDelegate { }

extension HomeViewController: UICollectionViewDataSource {
    // Кол-во секций
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    // Кол-во эллементов в секциях
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return hourlyForecast.count
        } else {
            return weather?.forecast.forecastday.count ?? 0
        }
    }
    // Внешний вид ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let weather = weather else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HourlyWeatherCell.reuseID,
                for: indexPath) as! HourlyWeatherCell
            
            let hour = hourlyForecast[indexPath.item]
            cell.configure(with: hour)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DailyWeatherCell.reuseID,
                for: indexPath) as! DailyWeatherCell
            
            let forecastDay = weather.forecast.forecastday[indexPath.item]
            cell.configure(with: forecastDay)
            
            return cell
        }
    }
    // Заголовок секции
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.reuseID,
                for: indexPath
            ) as! SectionHeaderView
            
            let title = indexPath.section == 0 ? "Почасовой прогноз" : "Прогноз погоды на \(self.weather?.forecast.forecastday.count ?? 0) дней"
            header.configure(with: title)
            
            return header
        }
        return UICollectionReusableView()
    }
    
}
