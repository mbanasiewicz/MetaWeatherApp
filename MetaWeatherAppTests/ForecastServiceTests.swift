//  MetaWeatherAppTests
//  Created by Maciej Banasiewicz on 2022-05-09.

import XCTest
@testable import MetaWeatherApp

final class ForecastServiceTests: XCTestCase {
    let testDependencies = TestDependencies()
    lazy var sut = ForecastService(dependencies: testDependencies)
    
    func testParsingJson_whenDataIsCorrect_shouldParse() async throws {
        // Arrange
        let londonData = try Data(json: "london_valid")
        testDependencies.fakeHttpClient.responseClosure = { _ in londonData }
        
        // Act
        let forecast = try await sut.loadForecast(for: [City.supportedCities[0]])
        
        // Assert
        print(forecast)
    }
}
