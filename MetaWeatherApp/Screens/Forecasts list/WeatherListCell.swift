//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import UIKit

final class WeatherListCell: UICollectionViewCell {
    typealias Dependencies = HasImageLoader
    var dependencies: Dependencies!
    
    private let cityNameLabel = UILabel()
    private let weatherDetailsLabel = UILabel()
    private let weatherImageView = UIImageView()
    
    var forecast: ForecastViewModel? {
        didSet {
            guard let forecast = forecast else { return }
            cityNameLabel.text = forecast.cityName
            weatherDetailsLabel.text = forecast.currentTemperature + "\n" + forecast.airPressure
            if let imageUrl = forecast.weatherImageUrl {
                weatherImageView.loadImage(
                    url: imageUrl,
                    imageLoader: dependencies.imageLoader
                )
            } else {
                weatherImageView.cancelImageLoading()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(weatherDetailsLabel)
        contentView.addSubview(weatherImageView)
        configureLabels()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabels() {
        cityNameLabel.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .bold)
        weatherDetailsLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .medium)
        weatherDetailsLabel.numberOfLines = 0
        weatherImageView.contentMode = .scaleAspectFit
        weatherImageView.image = UIImage(systemName: "cloud")
    }
    
    private func setupConstraints() {
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cityNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            weatherImageView.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor),
            weatherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            weatherImageView.widthAnchor.constraint(equalToConstant: 32),
            weatherImageView.centerYAnchor.constraint(equalTo: weatherDetailsLabel.centerYAnchor),
            
            weatherDetailsLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 8),
            weatherDetailsLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor, constant: 16),
            weatherDetailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weatherDetailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
