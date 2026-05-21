import Foundation

final class MJRSettingsStore {
    private let defaults = UserDefaults.standard

    func load() -> MJRSettings {
        guard let data = defaults.data(forKey: MJRStorageKey.settings) else { return .standard }
        do {
            return try JSONDecoder().decode(MJRSettings.self, from: data)
        } catch {
            return .standard
        }
    }

    func save(_ settings: MJRSettings) {
        do {
            let data = try JSONEncoder().encode(settings)
            defaults.set(data, forKey: MJRStorageKey.settings)
        } catch {
            NSLog("Failed to save settings: \(error.localizedDescription)")
        }
    }
}
