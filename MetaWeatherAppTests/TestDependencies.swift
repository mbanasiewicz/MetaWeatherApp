//  MetaWeatherAppTests
//  Created by Maciej Banasiewicz on 2022-05-09.

import UIKit
@testable import MetaWeatherApp

final class FakeImageLoader: ImageLoaderType {
    func loadImage(urlRequest: URLRequest) async throws -> UIImage {
        throw SimpleError(reason: "not implemented")
    }
}

final class FakeHTTPClient: HTTPClientType {
    var responseClosure: (URLRequest) -> Data = { _ in fatalError() }
    
    var requests: [URLRequest] = []
    
    func loadData(request: URLRequest) async throws -> Data {
        requests.append(request)
        return responseClosure(request)
    }
}

final class TestDependencies: AllDependencies {
    var fakeImageLoader = FakeImageLoader()
    var imageLoader: ImageLoaderType { fakeImageLoader }
    
    var fakeHttpClient: FakeHTTPClient = FakeHTTPClient()
    var httpClient: HTTPClientType { fakeHttpClient }
}
