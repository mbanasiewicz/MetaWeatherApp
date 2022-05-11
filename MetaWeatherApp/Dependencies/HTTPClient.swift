//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import Foundation

protocol HasHTTPClient {
    var httpClient: HTTPClientType { get }
}

protocol HTTPClientType: AnyObject {
    func loadData(request: URLRequest) async throws -> Data
}

final class HTTPClient: HTTPClientType {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadData(request: URLRequest) async throws -> Data {
        // todo
        let (data, _) = try await session.data(for: request)
        return data
    }
}
