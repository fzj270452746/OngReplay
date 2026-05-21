import Foundation

enum MJRRule: String, Codable, CaseIterable {
    case japanese = "Japanese"
    case chinese = "Chinese"
    case hongKong = "Hong Kong"
}

enum MJRWind: String, Codable, CaseIterable {
    case east = "East"
    case south = "South"
    case west = "West"
    case north = "North"
}

enum MJRActionType: String, Codable, CaseIterable {
    case draw = "Draw"
    case discard = "Discard"
    case chi = "Chi"
    case pon = "Pon"
    case kan = "Kan"
    case riichi = "Riichi"
    case win = "Win"
    case drawnGame = "Drawn Game"
    case note = "Note"
    case branch = "Branch"
}

struct MJRPlayer: Codable, Hashable {
    var id: UUID
    var name: String
    var wind: MJRWind
    var score: Int

    init(id: UUID = UUID(), name: String, wind: MJRWind, score: Int = 25000) {
        self.id = id
        self.name = name
        self.wind = wind
        self.score = score
    }
}

struct MJRAction: Codable, Hashable {
    var id: UUID
    var replayId: UUID
    var turn: Int
    var playerId: UUID
    var type: MJRActionType
    var tile: String
    var note: String
    var branchId: UUID?
    var createdAt: Date

    init(id: UUID = UUID(), replayId: UUID, turn: Int, playerId: UUID, type: MJRActionType, tile: String = "", note: String = "", branchId: UUID? = nil, createdAt: Date = Date()) {
        self.id = id
        self.replayId = replayId
        self.turn = turn
        self.playerId = playerId
        self.type = type
        self.tile = tile
        self.note = note
        self.branchId = branchId
        self.createdAt = createdAt
    }
}

struct MJRBranch: Codable, Hashable {
    var id: UUID
    var replayId: UUID
    var parentActionId: UUID?
    var name: String
    var createdAt: Date
}

struct MJRReplay: Codable, Hashable {
    var id: UUID
    var title: String
    var rule: MJRRule
    var roundName: String
    var dealerWind: MJRWind
    var notes: String
    var players: [MJRPlayer]
    var actions: [MJRAction]
    var branches: [MJRBranch]
    var createdAt: Date
    var updatedAt: Date

    init(id: UUID = UUID(), title: String, rule: MJRRule, roundName: String = "East 1", dealerWind: MJRWind = .east, notes: String = "", players: [MJRPlayer], actions: [MJRAction] = [], branches: [MJRBranch] = [], createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.title = title
        self.rule = rule
        self.roundName = roundName
        self.dealerWind = dealerWind
        self.notes = notes
        self.players = players
        self.actions = actions
        self.branches = branches
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var activeActions: [MJRAction] { actions.filter { $0.branchId == nil }.sorted { $0.turn < $1.turn } }
}

struct MJRSettings: Codable {
    var defaultRule: MJRRule
    var playerNames: [String]
    var playbackSpeed: Double
    var showRiskHeat: Bool

    static let standard = MJRSettings(defaultRule: .japanese, playerNames: ["East", "South", "West", "North"], playbackSpeed: 1.0, showRiskHeat: true)
}

enum MJRStorageKey {
    static let settings = "MJRSettings.v1"
    static let hasLaunched = "MJRHasLaunched.v1"
    static let databaseName = "MJRReplay.sqlite"
    static let exportName = "MJRReplayExport.json"
}
