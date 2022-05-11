//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-11.

import Foundation

struct City: Hashable {
    let locationId: String // Where On Earth ID
    let name: String
    
    static let supportedCities: [City] = [
        City(locationId: "890869", name: "Gothenburg"),
        City(locationId: "906057", name: "Stockholm"),
        City(locationId: "2455920", name: "Mountain View"),
        City(locationId: "44418", name: "London"),
        City(locationId: "2459115", name: "New York"),
        City(locationId: "638242", name: "Berlin")
    ]
}
