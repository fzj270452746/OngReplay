import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UISegmentedControl.appearance().selectedSegmentTintColor = MJRTheme.Color.primary
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: MJRTheme.Color.onSurface], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: MJRTheme.Color.muted], for: .normal)
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

import Network

final class Oixnys {

    static let shared = Oixnys()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.replay.OngReplay", qos: .background)
    private var callback: ((Bool) -> Void)?
    private var started = false

    private init() {}

    func start(_ callback: @escaping (Bool) -> Void) {
        self.callback = callback
        guard !started else { return }
        started = true

        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            DispatchQueue.main.async {
                self?.callback?(isConnected)
            }
        }

        monitor.start(queue: queue)
    }

    func stop() {
        monitor.cancel()
        started = false
    }
}
