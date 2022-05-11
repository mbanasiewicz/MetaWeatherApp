//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-11.

import SwiftUI

struct ForecastDetailsView: View {
    private let forecastViewModel: ForecastViewModel
    
    init(
        forecastViewModel: ForecastViewModel
    ) {
        self.forecastViewModel = forecastViewModel
    }
    
    var body: some View {
        VStack {
            Text(forecast)
        }
    }
}

struct ForecastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastDetailsView(
            forecast: Forecast(
                city: City(
                    locationId: "1",
                    name: "Test",
                    coordinates: City.Coordinates.init(
                        latitude: 0,
                        longitude: 0
                    )
                ),
                forecastResponse: ForecastResponse(
                    time: Date(),
                    sunrise: Date(),
                    sunset: Date(),
                    timezone: "CET",
                    weather: []
                )
            )
        )
    }
}
