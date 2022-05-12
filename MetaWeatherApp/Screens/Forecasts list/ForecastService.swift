//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import Foundation

protocol ForecastServiceType: AnyObject {
    func loadForecasts(for cities: [City]) async throws -> [Forecast]
}

final class ForecastService: ForecastServiceType {
    typealias Dependencies = HasHTTPClient
    
    private let baseUrl = URL(string: "https://www.metaweather.com/api/")!
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
    
    private func loadForcast(for city: City) async throws -> Forecast {
        let url = baseUrl.appendingPathComponent("location/\(city.locationId)")
        let request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10
        )
        
        let httpClient = dependencies.httpClient
        let data = try await httpClient.loadData(request: request)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601WithFractionalSeconds)
        
        return try decoder.decode(Forecast.self, from: data)
    }
}
