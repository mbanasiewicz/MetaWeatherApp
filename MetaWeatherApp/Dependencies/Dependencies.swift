//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import Foundation

typealias AllDependencies = HasHTTPClient & HasImageLoader

final class Dependencies: AllDependencies {
    let httpClient: HTTPClientType = HTTPClient()
    lazy var imageLoader: ImageLoaderType = ImageLoader(dependencies: self)
}
