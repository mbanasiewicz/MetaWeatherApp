//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-11.

import Foundation

struct Forecast: Decodable, Hashable {
    let title: String
    let locationId: Int
    let time: Date
    let sunrise: Date
    let sunset: Date
    let weather: [Weather]
    
    struct Weather: Decodable, Hashable {
        let stateName: String
        let stateNameAbbreviation: String
        let windDirectionCompass: String
        let minimumTemperature: Double
        let maximumTemperature: Double
        let currentTemperature: Double
        let windSpeed: Double
        let airPressure: Double
        let humidity: UInt
        let visibility: Double
        let predictability: UInt
        
        enum CodingKeys: String, CodingKey {
            case stateName = "weather_state_name"
            case stateNameAbbreviation = "weather_state_abbr"
            case windDirectionCompass = "wind_direction_compass"
            case minimumTemperature = "min_temp"
            case maximumTemperature = "max_temp"
            case currentTemperature = "the_temp"
            case windSpeed = "wind_speed"
            case airPressure = "air_pressure"
            case humidity
            case visibility
            case predictability
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case locationId = "woeid"
        case time
        case sunrise = "sun_rise"
        case sunset = "sun_set"
        case weather = "consolidated_weather"
    }
}
