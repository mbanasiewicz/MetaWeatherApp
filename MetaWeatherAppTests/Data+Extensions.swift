//  MetaWeatherAppTests
//  Created by Maciej Banasiewicz on 2022-05-09.

import Foundation

extension Data {
    enum Error: Swift.Error {
        case fileNotFound
    }
    
    init(json fileName: String) throws {
        final class BundleMarker {}
        
        guard let url = Bundle(for: BundleMarker.self).url(forResource: fileName, withExtension: "json") else {
            throw Error.fileNotFound
        }
        
        try self.init(contentsOf: url)
    }
}
