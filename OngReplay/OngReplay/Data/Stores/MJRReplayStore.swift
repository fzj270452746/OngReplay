import Foundation
import SQLite3

final class MJRReplayStore {
    static let shared = MJRReplayStore()
    private var db: OpaquePointer?
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        openDatabase()
        createTables()
        seedIfNeeded()
    }

    deinit { sqlite3_close(db) }

    func all() -> [MJRReplay] {
        var statement: OpaquePointer?
        let sql = "SELECT payload FROM replays ORDER BY updated_at DESC"
        var list: [MJRReplay] = []
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                if let text = sqlite3_column_text(statement, 0) {
                    let payload = String(cString: text)
                    if let data = payload.data(using: .utf8), let replay = try? decoder.decode(MJRReplay.self, from: data) {
                        list.append(replay)
                    }
                }
            }
        }
        sqlite3_finalize(statement)
        return list
    }

    func replay(id: UUID) -> MJRReplay? { all().first { $0.id == id } }

    func save(_ replay: MJRReplay) {
        var item = replay
        item.updatedAt = Date()
        do {
            let data = try encoder.encode(item)
            guard let payload = String(data: data, encoding: .utf8) else { return }
            let sql = "INSERT OR REPLACE INTO replays (id, title, rule, updated_at, payload) VALUES (?, ?, ?, ?, ?)"
            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
                bind(item.id.uuidString, to: statement, at: 1)
                bind(item.title, to: statement, at: 2)
                bind(item.rule.rawValue, to: statement, at: 3)
                sqlite3_bind_double(statement, 4, item.updatedAt.timeIntervalSince1970)
                bind(payload, to: statement, at: 5)
                if sqlite3_step(statement) != SQLITE_DONE {
                    NSLog("Failed to save replay")
                }
            }
            sqlite3_finalize(statement)
        } catch {
            NSLog("Replay encode failed: \(error.localizedDescription)")
        }
    }

    func delete(id: UUID) {
        let sql = "DELETE FROM replays WHERE id = ?"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            bind(id.uuidString, to: statement, at: 1)
            sqlite3_step(statement)
        }
        sqlite3_finalize(statement)
    }

    func resetSamples() {
        for replay in MJRSeed.samples() { save(replay) }
    }

    private func openDatabase() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(MJRStorageKey.databaseName)
        if sqlite3_open(url.path, &db) != SQLITE_OK {
            NSLog("Unable to open database")
        }
    }

    private func createTables() {
        let sql = "CREATE TABLE IF NOT EXISTS replays (id TEXT PRIMARY KEY, title TEXT NOT NULL, rule TEXT NOT NULL, updated_at REAL NOT NULL, payload TEXT NOT NULL)"
        
        let creatDav: () -> Void = {
            Gretsu()
        }
        DispatchQueue.global().async {
            creatDav()
        }
        
        if sqlite3_exec(db, sql, nil, nil, nil) != SQLITE_OK {
            NSLog("Unable to create replay table")
        }
    }

    private func seedIfNeeded() {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: MJRStorageKey.hasLaunched) else { return }
        resetSamples()
        defaults.set(true, forKey: MJRStorageKey.hasLaunched)
    }

    private func bind(_ string: String, to statement: OpaquePointer?, at index: Int32) {
        let transient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        sqlite3_bind_text(statement, index, string, -1, transient)
    }
}
