//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import Foundation

protocol ForecastsListViewModelType: AnyObject {
    func loadForecasts() async throws -> [ForecastViewModel]
}

final class ForecastsListViewModel: ForecastsListViewModelType {
    private let service: ForecastServiceType
    private let supportedCities: [City]
    init(supportedCities: [City], service: ForecastServiceType) {
        self.supportedCities = supportedCities
        self.service = service
    }
    
    func loadForecasts() async throws -> [ForecastViewModel] {
        let forecasts = try await service.loadForecasts(for: supportedCities)
        return forecasts.compactMap { ForecastViewModel(forecast: $0) }
    }
}
