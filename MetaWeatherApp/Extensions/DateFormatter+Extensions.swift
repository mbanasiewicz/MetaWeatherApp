//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import Foundation

extension DateFormatter {
    static let iso8601WithFractionalSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
}
