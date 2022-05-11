//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-10.

import SwiftUI

final class ForecastDetailsViewController: UIHostingController<ForecastDetailsView> {
    private let viewModel: ForecastViewModel
    init(
        viewModel: ForecastViewModel
    ) {
        self.viewModel = viewModel
        super.init(
            rootView: ForecastDetailsView(
                viewModel: viewModel
            )
        )
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.cityName
    }
}
