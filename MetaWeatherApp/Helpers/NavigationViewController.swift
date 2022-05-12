//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-10.

import Foundation
import UIKit

final class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.font: UIFont.monospacedSystemFont(ofSize: 15, weight: .semibold)]
        navigationBar.standardAppearance = appearance
    }
}
