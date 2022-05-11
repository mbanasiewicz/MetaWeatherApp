//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-10.

import SwiftUI

final class ForecastDetailsViewController: UIHostingController<ForecastDetailsView> {
    init(forecast: Forecast) {
        super.init(rootView: ForecastDetailsView(forecast: forecast))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
