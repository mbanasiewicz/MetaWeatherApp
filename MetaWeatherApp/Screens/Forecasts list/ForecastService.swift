//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import Foundation

final class ForecastService {
    private let baseUrl = URL(string: "https://www.metaweather.com/api/")!
    typealias Dependencies = HasHTTPClient
    private let dependencies: Dependencies
    
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func loadForecasts(for cities: [City]) async throws -> [Forecast] {
        try await withThrowingTaskGroup(of: Forecast.self) { group in
            for city in cities {
                group.addTask {
                    try await self.loadForcast(for: city)
                }
            }
            
            return try await group.reduce([Forecast](), { partialResult, forecast in
                return partialResult + [forecast]
            })
        }
    }
    
    func loadForcast(for city: City) async throws -> Forecast {
        let url = baseUrl.appendingPathComponent("/api/location/\(city.locationId)")
        let request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10
        )
        
        let httpClient = dependencies.httpClient
        let data = try await httpClient.loadData(request: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601WithFractionalSeconds)
        
        let forecastResponse = try decoder.decode(ForecastResponse.self, from: data)
        return Forecast(city: city, forecastResponse: forecastResponse)
    }
}



struct ForecastResponse: Decodable, Hashable {
    let time: Date
    let sunrise: Date
    let sunset: Date
    let timezone: String
    let weather: [Weather]
    
    struct Weather: Decodable, Hashable {
        let weather_state_name: String
        let weather_state_abbr: String // Image url
        let wind_direction_compass: String
        let applicable_date: String // "2022-05-09",
        let min_temp: Double
        let max_temp: Double// 20.840000000000003,
        let the_temp: Double //19.939999999999998,
        let wind_speed: Double// 7.009147505639068,
        let wind_direction: Double// 198.17979199315087,
        let air_pressure: Double //1024.0,
        let humidity: UInt//56,
        let visibility: Double //10.009357850155094,
        let predictability: UInt//71
    }
    
    enum CodingKeys: String, CodingKey {
        case time
        case sunrise = "sun_rise"
        case sunset = "sun_set"
        case timezone = "timezone_name"
        case weather = "consolidated_weather"
    }
}

/**
 
 {
   "consolidated_weather": [
     {
       "id": 4587304287993856,
       "weather_state_name": "Heavy Cloud",
       "weather_state_abbr": "hc",
       "wind_direction_compass": "SSW",
       "created": "2022-05-09T12:59:02.262629Z",
       "applicable_date": "2022-05-09",
       "min_temp": 7.109999999999999,
       "max_temp": 20.840000000000003,
       "the_temp": 19.939999999999998,
       "wind_speed": 7.009147505639068,
       "wind_direction": 198.17979199315087,
       "air_pressure": 1024.0,
       "humidity": 56,
       "visibility": 10.009357850155094,
       "predictability": 71
     },
     {
       "id": 5482082944942080,
       "weather_state_name": "Showers",
       "weather_state_abbr": "s",
       "wind_direction_compass": "WSW",
       "created": "2022-05-09T12:59:02.454050Z",
       "applicable_date": "2022-05-10",
       "min_temp": 12.920000000000002,
       "max_temp": 19.545,
       "the_temp": 18.1,
       "wind_speed": 8.53690051090697,
       "wind_direction": 248.81889868153166,
       "air_pressure": 1015.5,
       "humidity": 65,
       "visibility": 12.648010617990932,
       "predictability": 73
     },
     {
       "id": 6389263521284096,
       "weather_state_name": "Showers",
       "weather_state_abbr": "s",
       "wind_direction_compass": "SW",
       "created": "2022-05-09T12:59:02.952121Z",
       "applicable_date": "2022-05-11",
       "min_temp": 11.155000000000001,
       "max_temp": 19.355,
       "the_temp": 17.799999999999997,
       "wind_speed": 9.64031459048225,
       "wind_direction": 223.004893250991,
       "air_pressure": 1011.0,
       "humidity": 62,
       "visibility": 9.691837170921817,
       "predictability": 73
     },
     {
       "id": 5532694034251776,
       "weather_state_name": "Heavy Cloud",
       "weather_state_abbr": "hc",
       "wind_direction_compass": "WSW",
       "created": "2022-05-09T12:59:02.943365Z",
       "applicable_date": "2022-05-12",
       "min_temp": 8.86,
       "max_temp": 19.14,
       "the_temp": 17.935000000000002,
       "wind_speed": 7.584288863217477,
       "wind_direction": 238.2091568090691,
       "air_pressure": 1018.0,
       "humidity": 50,
       "visibility": 14.420782629444046,
       "predictability": 71
     },
     {
       "id": 4688911470166016,
       "weather_state_name": "Showers",
       "weather_state_abbr": "s",
       "wind_direction_compass": "WSW",
       "created": "2022-05-09T12:59:02.489481Z",
       "applicable_date": "2022-05-13",
       "min_temp": 10.295,
       "max_temp": 18.535,
       "the_temp": 17.425,
       "wind_speed": 8.83905383921896,
       "wind_direction": 253.50083982409097,
       "air_pressure": 1018.5,
       "humidity": 61,
       "visibility": 14.540707269545852,
       "predictability": 73
     },
     {
       "id": 4676259905798144,
       "weather_state_name": "Showers",
       "weather_state_abbr": "s",
       "wind_direction_compass": "NNE",
       "created": "2022-05-09T12:59:05.053088Z",
       "applicable_date": "2022-05-14",
       "min_temp": 10.149999999999999,
       "max_temp": 20.57,
       "the_temp": 18.05,
       "wind_speed": 4.000268631193828,
       "wind_direction": 12.499999999999996,
       "air_pressure": 1021.0,
       "humidity": 61,
       "visibility": 9.999726596675416,
       "predictability": 73
     }
   ],
   "time": "2022-05-09T14:00:00.287129+01:00",
   "sun_rise": "2022-05-09T05:18:21.008150+01:00",
   "sun_set": "2022-05-09T20:36:35.881982+01:00",
   "timezone_name": "LMT",
   "parent": {
     "title": "England",
     "location_type": "Region / State / Province",
     "woeid": 24554868,
     "latt_long": "52.883560,-1.974060"
   },
   "sources": [
     {
       "title": "BBC",
       "slug": "bbc",
       "url": "http://www.bbc.co.uk/weather/",
       "crawl_rate": 360
     },
     {
       "title": "Forecast.io",
       "slug": "forecast-io",
       "url": "http://forecast.io/",
       "crawl_rate": 480
     },
     {
       "title": "HAMweather",
       "slug": "hamweather",
       "url": "http://www.hamweather.com/",
       "crawl_rate": 360
     },
     {
       "title": "Met Office",
       "slug": "met-office",
       "url": "http://www.metoffice.gov.uk/",
       "crawl_rate": 180
     },
     {
       "title": "OpenWeatherMap",
       "slug": "openweathermap",
       "url": "http://openweathermap.org/",
       "crawl_rate": 360
     },
     {
       "title": "Weather Underground",
       "slug": "wunderground",
       "url": "https://www.wunderground.com/?apiref=fc30dc3cd224e19b",
       "crawl_rate": 720
     },
     {
       "title": "World Weather Online",
       "slug": "world-weather-online",
       "url": "http://www.worldweatheronline.com/",
       "crawl_rate": 360
     }
   ],
   "title": "London",
   "location_type": "City",
   "woeid": 44418,
   "latt_long": "51.506321,-0.12714",
   "timezone": "Europe/London"
 }
 */
