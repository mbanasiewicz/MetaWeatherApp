//  MetaWeatherAppTests
//  Created by Maciej Banasiewicz on 2022-05-12.

import XCTest
@testable import MetaWeatherApp

final class ForecastsListViewModelTests: XCTestCase {
    func testLoadForecasts_whenCalled_shouldRequestSpecifiedCities() async throws {
        // Arrange
        let fakeService = FakeForecastService()
        let testCity = City(locationId: "test", name: "Stockholm")
        let sut = ForecastsListViewModel(
            supportedCities: [testCity],
            service: fakeService
        )
        
        // Act
        let _ = try await sut.loadForecasts()
        
        // Assert
        XCTAssertEqual(fakeService.requestedCities, [testCity])
    }
}

private final class FakeForecastService: ForecastServiceType {
    
    var requestedCities: [City]?
    
    func loadForecasts(for cities: [City]) async throws -> [Forecast] {
        requestedCities = cities
        return []
    }
}
