import Foundation

struct MJRTile: Hashable {
    enum Kind: Hashable {
        case man(Int)
        case pin(Int)
        case sou(Int)
        case wind(String)
        case dragon(String)
        case unknown
    }

    let code: String
    let title: String

    var kind: Kind {
        if let value = Int(code.dropLast()), let last = code.last {
            if last == "m" { return .man(value) }
            if last == "p" { return .pin(value) }
            if last == "s" { return .sou(value) }
        }
        if ["East", "South", "West", "North"].contains(code) { return .wind(code) }
        if ["White", "Green", "Red"].contains(code) { return .dragon(code) }
        return .unknown
    }

    static let all: [MJRTile] = {
        let man = (1...9).map { MJRTile(code: "\($0)m", title: "\($0)m") }
        let pin = (1...9).map { MJRTile(code: "\($0)p", title: "\($0)p") }
        let sou = (1...9).map { MJRTile(code: "\($0)s", title: "\($0)s") }
        let honors = ["East", "South", "West", "North", "White", "Green", "Red"].map { MJRTile(code: $0, title: $0) }
        return man + pin + sou + honors
    }()

    static func title(for code: String) -> String {
        all.first { $0.code == code }?.title ?? code
    }

    static func find(_ code: String) -> MJRTile {
        all.first { $0.code == code } ?? MJRTile(code: code, title: code)
    }
}

struct MJRBoardState {
    var hands: [UUID: [String]] = [:]
    var rivers: [UUID: [String]] = [:]
    var melds: [UUID: [String]] = [:]
    var riichiPlayers: Set<UUID> = []
    var lastAction: MJRAction?
}
