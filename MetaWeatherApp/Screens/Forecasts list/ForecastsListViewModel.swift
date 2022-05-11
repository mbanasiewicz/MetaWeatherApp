//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import Foundation

struct City: Hashable {
    struct Coordinates: Hashable {
        let latitude: Double
        let longitude: Double
    }
    
    let locationId: String // Where On Earth ID
    let name: String
    let coordinates: Coordinates
    
    static let supportedCities: [City] = [
        City(locationId: "890869", name: "Gothenburg", coordinates: .init(latitude: 57.701328, longitude: 11.96689)),
        City(locationId: "906057", name: "Stockholm", coordinates: .init(latitude: 59.332169, longitude: 18.062429)),
        City(locationId: "2455920", name: "Mountain View", coordinates: .init(latitude: 37.39999, longitude: -122.079552)),
        City(locationId: "44418", name: "London", coordinates: .init(latitude: 51.506321, longitude: -0.12714)),
        City(locationId: "2459115", name: "New York", coordinates: .init(latitude: 40.71455, longitude: -74.007118)),
        City(locationId: "638242", name: "Berlin", coordinates: .init(latitude: 52.516071, longitude: 13.376980))
    ]
}

protocol ForecastsListViewModelType: AnyObject {
    func loadForecasts() async throws -> [ForecastViewModel]
}

struct Forecast: Hashable {
    let city: City
    let forecastResponse: ForecastResponse
}

final class ForecastsListViewModel: ForecastsListViewModelType {
    typealias Dependencies = ForecastService.Dependencies
    private let dependencies: Dependencies
    private let service: ForecastService
    
    init(dependencies: Dependencies) {
        self.service = ForecastService(dependencies: dependencies)
        self.dependencies = dependencies
    }
    
    func loadForecasts() async throws -> [ForecastViewModel] {
        let forecasts = try await service.loadForecasts(for: City.supportedCities)
        let forecastsViewModels = forecasts.compactMap { ForecastViewModel.init(forecast: $0) }
        return forecastsViewModels
    }
}

struct ForecastViewModel: Hashable {
    let locationId: String
    let cityName: String
    let temperature: String
    let weatherImageUrl: URL?
    let airPressure: String
    
    init?(forecast: Forecast) {
        guard let weather = forecast.forecastResponse.weather.first else { return nil }
        let mf = MeasurementFormatter()
        
        locationId = forecast.city.locationId
        cityName = forecast.city.name
        let currentTemperature = mf.string(from: Measurement(value: weather.the_temp, unit: UnitTemperature.celsius))
        let minTemperature = mf.string(from: Measurement(value: weather.min_temp, unit: UnitTemperature.celsius))
        let maxTemperature = mf.string(from: Measurement(value: weather.max_temp, unit: UnitTemperature.celsius))
        temperature = "\(currentTemperature) \(minTemperature) - \(maxTemperature)"
        weatherImageUrl = URL(string: "https://www.metaweather.com/static/img/weather/png/64/\(weather.weather_state_abbr).png")
        let pressureMeasurement = Measurement(value: weather.air_pressure, unit: UnitPressure.millibars)
        airPressure = MeasurementFormatter().string(from: pressureMeasurement)
    }
}

//"weather_state_name": "Heavy Cloud",
//"weather_state_abbr": "hc",
//"wind_direction_compass": "SSW",
//"created": "2022-05-09T12:59:02.262629Z",
//"applicable_date": "2022-05-09",
//"min_temp": 7.109999999999999,
//"max_temp": 20.840000000000003,
//"the_temp": 19.939999999999998,
//"wind_speed": 7.009147505639068,
//"wind_direction": 198.17979199315087,
//"air_pressure": 1024.0,
//"humidity": 56,
//"visibility": 10.009357850155094,
//"predictability": 71
