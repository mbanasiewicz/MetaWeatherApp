//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-11.

import SwiftUI

struct ForecastDetailsView: View {
    private let viewModel: ForecastViewModel
    
    init(
        viewModel: ForecastViewModel
    ) {
        self.viewModel = viewModel
    }
    
    private let titleFont = Font.system(size: 32).monospaced()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: viewModel.weatherImageUrl) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 32, height: 32)
                MeasurementView(title: "Current weather", value: viewModel.stateName)
                MeasurementView(title: "Temperature", value: viewModel.currentTemperature)
                MeasurementView(title: "Min. temperature", value: viewModel.minimumTemperature)
                MeasurementView(title: "Max. temperature", value: viewModel.maximumTemperature)
                MeasurementView(title: "Air pressure", value: viewModel.airPressure)
                MeasurementView(title: "Wind speed", value: viewModel.windSpeed)
                MeasurementView(title: "Wind direction", value: viewModel.windDirectionCompass)
                MeasurementView(title: "Humidity", value: viewModel.humidity)
                MeasurementView(title: "Visibility", value: viewModel.visibility)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct MeasurementView: View {
    let title: String
    let value: String
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        Text("\(title): \(value)")
            .font(
                Font.system(size: 17).monospaced()
            )
    }
}

struct ForecastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastDetailsView(
            viewModel: .init(
                locationId: "",
                cityName: "Stockholm",
                currentTemperature: "10℃",
                minimumTemperature: "5℃",
                maximumTemperature: "15℃",
                weatherImageUrl: URL(string: "https://www.metaweather.com/static/img/weather/png/64/hc.png"),
                airPressure: "1000 hPa",
                stateName: "Cloudy",
                windDirectionCompass: "SSW",
                windSpeed: "100 km/h",
                humidity: "50%",
                visibility: "1100m"
            )
        )
    }
}
