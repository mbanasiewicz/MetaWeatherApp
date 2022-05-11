//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import Foundation

protocol ForecastsListViewModelType: AnyObject {
    func loadForecasts() async throws -> [ForecastViewModel]
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
        do {
            let forecasts = try await service.loadForecasts(for: City.supportedCities)
            let viewModels = forecasts.compactMap { ForecastViewModel.init(forecast: $0) }
            return viewModels
        } catch {
            print(error)
            return []
        }
        
    }
}
