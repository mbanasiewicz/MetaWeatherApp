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
        let forecasts = try await sut.loadForecasts(for: [City.supportedCities[0]])
        
        // Assert
        let forecast = try XCTUnwrap(forecasts.first)
        
        XCTAssertEqual(forecast.title, "London")
        XCTAssertEqual(forecast.weather.count, 6)
    }
    
    func testLoading_whenCalled_shouldUseCityId() async throws {
        // Arrange
        let londonData = try Data(json: "london_valid")
        testDependencies.fakeHttpClient.responseClosure = { _ in londonData }
        let testCity = City(locationId: "testId", name: "Stockholm")
        let expectedUrl = URL(string: "https://www.metaweather.com/api/location/testId")!
        
        // Act
        let _ = try await sut.loadForecasts(for: [testCity])
        
        // Assert
        let requestUrl = try XCTUnwrap(testDependencies.fakeHttpClient.requests.first?.url)
        XCTAssertEqual(requestUrl, expectedUrl)
    }
}
