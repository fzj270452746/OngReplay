import Foundation

enum MJRSeed {
    static func players() -> [MJRPlayer] {
        [
            MJRPlayer(name: "Aki", wind: .east),
            MJRPlayer(name: "Ben", wind: .south),
            MJRPlayer(name: "Chou", wind: .west),
            MJRPlayer(name: "Dana", wind: .north)
        ]
    }

    static func emptyReplay(title: String = "New Replay", rule: MJRRule = .japanese) -> MJRReplay {
        MJRReplay(title: title, rule: rule, players: players())
    }

    static func samples() -> [MJRReplay] {
        var replay = emptyReplay(title: "East 1 Riichi Push", rule: .japanese)
        let east = replay.players[0].id
        let south = replay.players[1].id
        replay.actions = [
            MJRAction(replayId: replay.id, turn: 1, playerId: east, type: .draw, tile: "5m"),
            MJRAction(replayId: replay.id, turn: 2, playerId: east, type: .discard, tile: "9p"),
            MJRAction(replayId: replay.id, turn: 3, playerId: south, type: .draw, tile: "East"),
            MJRAction(replayId: replay.id, turn: 4, playerId: south, type: .riichi, note: "Early riichi pressure"),
            MJRAction(replayId: replay.id, turn: 5, playerId: east, type: .discard, tile: "8p", note: "Review this push"),
            MJRAction(replayId: replay.id, turn: 6, playerId: south, type: .win, tile: "8p")
        ]
        var replay2 = emptyReplay(title: "Open Hand Speed Race", rule: .hongKong)
        let player = replay2.players[2].id
        replay2.actions = [
            MJRAction(replayId: replay2.id, turn: 1, playerId: player, type: .draw, tile: "Green"),
            MJRAction(replayId: replay2.id, turn: 2, playerId: player, type: .pon, tile: "Green"),
            MJRAction(replayId: replay2.id, turn: 3, playerId: player, type: .discard, tile: "1m"),
            MJRAction(replayId: replay2.id, turn: 4, playerId: player, type: .win, tile: "Red")
        ]
        return [replay, replay2]
    }
}
