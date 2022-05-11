//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        .makeMainWindowScene(role: connectingSceneSession.role)
    }
    
    

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        
    }
}

private extension UISceneConfiguration {
    static func makeMainWindowScene(role: UISceneSession.Role) -> UISceneConfiguration {
        .init(name: "Default Configuration", sessionRole: role)
    }
}
