//
//  TestDependencies.swift
//  MetaWeatherAppTests
//
//  Created by Maciej Banasiewicz on 2022-05-09.
//

import Foundation
@testable import MetaWeatherApp

final class FakeHTTPClient: HTTPClientType {
    var responseClosure: (URLRequest) -> Data = { _ in fatalError() }
    
    func loadData(request: URLRequest) async throws -> Data {
        responseClosure(request)
    }
}

final class TestDependencies: AllDependencies {
    var fakeHttpClient: FakeHTTPClient = FakeHTTPClient()
    var httpClient: HTTPClientType { fakeHttpClient }
}
