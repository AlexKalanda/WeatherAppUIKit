
import UIKit

final class HomeView: UIView {
    //MARK: - Свойства
    lazy var colletionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        cv.register(HourlyWeatherCell.self, forCellWithReuseIdentifier: HourlyWeatherCell.reuseID)
        cv.register(DailyWeatherCell.self, forCellWithReuseIdentifier: DailyWeatherCell.reuseID)
        cv.register(SectionHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: SectionHeaderView.reuseID)
        cv.collectionViewLayout = createLayout()
        return cv
    }()
    
    lazy var  cityLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        lbl.textColor = .label
        return lbl
    }()
    
    lazy var  currentTemp: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 48, weight: .medium)
        lbl.textColor = .label
        return lbl
    }()
    
    lazy var  descriptionWeather: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16, weight: .bold)
        lbl.textColor = .blue
        return lbl
    }()
    
    lazy var  maxminTemp: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .medium)
        lbl.textColor = .label
        return lbl
    }()
    
    lazy var  separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = .lightGray
        return separator
    }()
    
    init() {
        super.init(frame: .zero)
        setConstraints()
        setViews()
    }
    
        //Настройка View
    private func setViews() {
        backgroundColor = .systemBackground
    }
    //Настройка View(размещение объектов)
    private func setConstraints() {
        
        addSubview(cityLbl)
        cityLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityLbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityLbl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        addSubview(currentTemp)
        currentTemp.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentTemp.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentTemp.topAnchor.constraint(equalTo: cityLbl.bottomAnchor, constant: 5)
        ])
        
        addSubview(descriptionWeather)
        descriptionWeather.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionWeather.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionWeather.topAnchor.constraint(equalTo: currentTemp.bottomAnchor, constant: 5)
        ])
        
        addSubview(maxminTemp)
        maxminTemp.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            maxminTemp.centerXAnchor.constraint(equalTo: centerXAnchor),
            maxminTemp.topAnchor.constraint(equalTo: descriptionWeather.bottomAnchor)
        ])
        
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            separator.topAnchor.constraint(equalTo: maxminTemp.bottomAnchor, constant: 20),
            separator.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale)
        ])
        
        addSubview(colletionView)
        colletionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            colletionView.topAnchor.constraint(equalTo: separator.bottomAnchor),
            colletionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            colletionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            colletionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    // Настройка Loyout
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            if sectionIndex == 0 {
                return self.createHourlySectionLayout()
            } else {
                return self.createDailySectionLoyout()
            }
        }
        
        return layout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
