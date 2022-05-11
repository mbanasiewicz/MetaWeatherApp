//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-10.

import Foundation
import UIKit

protocol ImageLoaderType: AnyObject {
    func loadImage(urlRequest: URLRequest) async throws -> UIImage
}

protocol HasImageLoader {
    var imageLoader: ImageLoaderType { get }
}

final class ImageLoader: ImageLoaderType {
    typealias Dependencies = HasHTTPClient
    let dependencies: Dependencies
    
    enum Error: Swift.Error {
        case unableToCreateImageFromData
    }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func loadImage(urlRequest: URLRequest) async throws -> UIImage {
        let data = try await dependencies.httpClient.loadData(request: urlRequest)
        try Task.checkCancellation()
        guard let image = UIImage(data: data) else { throw Error.unableToCreateImageFromData }
        return image
    }
}
