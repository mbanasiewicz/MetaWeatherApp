//  MetaWeatherAppTests
//  Created by Maciej Banasiewicz on 2022-05-11.

import XCTest
@testable import MetaWeatherApp

final class ForecastsListViewControllerTests: XCTestCase {
    private let vm = FakeForecastsListViewModel()
    private let testDependencies = TestDependencies()
    
    func testLoadingData_whenViewLoads_shouldCallLoad() {
        // Arrange
        let sut = ForecastsListViewController(viewModel: vm, dependencies: testDependencies)
        let loadForecastsExpectation = expectation(description: "loads forecasts")
        vm.onDidCallLoadForecasts = {
            loadForecastsExpectation.fulfill()
        }
        // Act
        _ = sut.view
        
        // Assert
        waitForExpectations(timeout: 1)
    }
    
    func testLoadingData_whenLoadingFails_shouldPresentAlert() {
        // Arrange
        vm.result = .failure(SimpleError(reason: "expected failure"))
        
        // The presentation will not happen unless the vc is in a view hierarchy
        let window = UIWindow(frame: UIScreen.main.bounds)
        let sut = ForecastsListViewController(viewModel: vm, dependencies: testDependencies)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
        let predicate = NSPredicate(format: "%K != nil", #keyPath(UIViewController.presentedViewController))
        let presentViewControllerExpectation = XCTNSPredicateExpectation(predicate: predicate, object: sut)

        // Act
        _ = sut.view
        
        // Assert
        wait(for: [presentViewControllerExpectation], timeout: 2.0)
    }
    
    func testTitle_afterInit_shouldBeSet() {
        // Arrange
        let sut = ForecastsListViewController(viewModel: vm, dependencies: testDependencies)
        // Act
        // Assert
        XCTAssertEqual(sut.title, "Meta Weather")
    }
}

private final class FakeForecastsListViewModel: ForecastsListViewModelType {
    var result: Result<[ForecastViewModel], Error> = .success([])
    
    var onDidCallLoadForecasts: () -> Void = {}
    
    func loadForecasts() async throws -> [ForecastViewModel] {
        onDidCallLoadForecasts()
        switch result {
        case .success(let viewModels): return viewModels
        case .failure(let error): throw error
        }
    }
}
