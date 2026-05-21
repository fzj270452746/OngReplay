import UIKit
import AppTrackingTransparency

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let home = MJRHomeViewController()
        let navigation = UINavigationController(rootViewController: home)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.navigationBar.tintColor = MJRTheme.Color.secondary
        navigation.navigationBar.largeTitleTextAttributes = [.foregroundColor: MJRTheme.Color.onSurface]
        navigation.navigationBar.titleTextAttributes = [.foregroundColor: MJRTheme.Color.onSurface]
        window.rootViewController = navigation
        window.tintColor = MJRTheme.Color.secondary
        window.backgroundColor = MJRTheme.Color.background
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
    }
}
