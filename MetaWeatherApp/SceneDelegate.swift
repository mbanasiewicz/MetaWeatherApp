//  MetaWeatherApp
//  Created by Maciej Banasiewicz on 2022-05-09.

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private let dependecies = Dependencies()
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene, !isRunningTests else { return }
        
        let newWindow = UIWindow(windowScene: windowScene)
        
        let rootViewController = ForecastsListViewController.make(using: dependecies)
        
        newWindow.rootViewController = NavigationController(rootViewController: rootViewController)
        
        window = newWindow
        
        newWindow.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

private let isRunningTests: Bool = {
    #if targetEnvironment(simulator)
    return NSClassFromString("XCTestCase") != nil
    #else
    return false
    #endif
}()
