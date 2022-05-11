//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-11.

import Foundation

struct ForecastViewModel: Hashable {
    let locationId: String
    let cityName: String
    let currentTemperature: String
    let minimumTemperature: String
    let maximumTemperature: String
    let weatherImageUrl: URL?
    let airPressure: String
    
    let stateName: String
    let windDirectionCompass: String
    let windSpeed: String
    let humidity: String
    let visibility: String
    
    init?(
        forecast: Forecast
    ) {
        // This is a simplification b/c I assume that the first forecast is the current one,
        // in reality we would need to check applicable_date prop including the time_zone_name
        guard let weather = forecast.weather.first else { return nil }
        self.init(
            forecast: forecast,
            weather: weather
        )
    }
    
    init(
        forecast: Forecast,
        weather: Forecast.Weather
    ) {
        locationId = "\(forecast.locationId)"
        cityName = forecast.title
        let mf = MeasurementFormatter()
        currentTemperature = mf.string(from: Measurement<UnitTemperature>(value: weather.currentTemperature, unit: .celsius))
        minimumTemperature = mf.string(from: Measurement<UnitTemperature>(value: weather.minimumTemperature, unit: .celsius))
        maximumTemperature = mf.string(from: Measurement<UnitTemperature>(value: weather.maximumTemperature, unit: .celsius))
        weatherImageUrl = URL(string: "https://www.metaweather.com/static/img/weather/png/64/\(weather.stateNameAbbreviation).png")
        airPressure = mf.string(from: Measurement<UnitPressure>(value: weather.airPressure, unit: .millibars))
        stateName = weather.stateName
        windDirectionCompass = weather.windDirectionCompass
        windSpeed = mf.string(from: Measurement<UnitSpeed>(value: weather.windSpeed, unit: .milesPerHour))
        humidity = "\(weather.humidity)%"
        visibility = mf.string(from: Measurement<UnitLength>(value: weather.visibility, unit: .meters))
    }
    
    init(
        locationId: String,
        cityName: String,
        currentTemperature: String,
        minimumTemperature: String,
        maximumTemperature: String,
        weatherImageUrl: URL?,
        airPressure: String,
        stateName: String,
        windDirectionCompass: String,
        windSpeed: String,
        humidity: String,
        visibility: String
    ) {
        self.locationId = locationId
        self.cityName = cityName
        self.currentTemperature = currentTemperature
        self.minimumTemperature = minimumTemperature
        self.maximumTemperature = maximumTemperature
        self.weatherImageUrl = weatherImageUrl
        self.airPressure = airPressure
        self.stateName = stateName
        self.windDirectionCompass = windDirectionCompass
        self.windSpeed = windSpeed
        self.humidity = humidity
        self.visibility = visibility
    }
}
