
import UIKit

final class DailyWeatherCell: UICollectionViewCell {
    static let reuseID = "DailyWeatherCell"
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let tempRangeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(tempRangeLabel)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        tempRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            tempRangeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tempRangeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with forecastDay: Forecastday) {
        dayLabel.text = forecastDay.formattedDate()
        tempRangeLabel.text = "\(Int(forecastDay.day.maxtempC))°/\(Int(forecastDay.day.mintempC))°"
    }
}
