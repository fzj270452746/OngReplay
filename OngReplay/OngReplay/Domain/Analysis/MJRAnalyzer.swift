import Foundation

struct MJRAnalysisNote: Hashable {
    var title: String
    var detail: String
    var level: Int
}

struct MJRAnalysisReport {
    var shantenText: String
    var efficiency: Int
    var risk: Int
    var notes: [MJRAnalysisNote]
    var riskSeries: [CGFloat]
}

struct MJRStatsSummary {
    var total: Int
    var wins: Int
    var riichi: Int
    var calls: Int
    var averageRisk: Int
    var winRate: Double
}

final class MJRAnalyzer {
    func report(for replay: MJRReplay) -> MJRAnalysisReport {
        let actions = replay.activeActions
        let discards = actions.filter { $0.type == .discard }
        let calls = actions.filter { [.chi, .pon, .kan].contains($0.type) }
        let riichiCount = actions.filter { $0.type == .riichi }.count
        let risk = min(96, 18 + discards.count * 3 + riichiCount * 16 + calls.count * 5)
        let efficiency = max(8, 88 - calls.count * 4 - actions.filter { $0.type == .note }.count * 2)
        let shanten = max(0, 6 - discards.count / 3 - calls.count)
        var notes = baseNotes(replay: replay, risk: risk, efficiency: efficiency)
        if let lastDiscard = discards.last, risk > 62 {
            notes.append(MJRAnalysisNote(title: "High pressure discard", detail: "\(lastDiscard.tile) was discarded after visible pressure increased.", level: 3))
        }
        let series = actions.enumerated().map { index, action in
            CGFloat(min(96, 12 + index * 4 + riskWeight(for: action))) / 100.0
        }
        return MJRAnalysisReport(shantenText: "Estimated \(shanten)-shanten", efficiency: efficiency, risk: risk, notes: notes, riskSeries: series.isEmpty ? [0.12, 0.18, 0.25] : series)
    }

    func stats(for replays: [MJRReplay]) -> MJRStatsSummary {
        let actions = replays.flatMap { $0.actions }
        let wins = actions.filter { $0.type == .win }.count
        let riichi = actions.filter { $0.type == .riichi }.count
        let calls = actions.filter { [.chi, .pon, .kan].contains($0.type) }.count
        let risk = replays.isEmpty ? 0 : replays.map { report(for: $0).risk }.reduce(0, +) / max(1, replays.count)
        return MJRStatsSummary(total: replays.count, wins: wins, riichi: riichi, calls: calls, averageRisk: risk, winRate: replays.isEmpty ? 0 : Double(wins) / Double(replays.count))
    }

    private func baseNotes(replay: MJRReplay, risk: Int, efficiency: Int) -> [MJRAnalysisNote] {
        var notes = [MJRAnalysisNote(title: "Rule context", detail: MJRRuleFactory.engine(for: replay.rule).actionHelp, level: 1)]
        notes.append(MJRAnalysisNote(title: "Tile efficiency", detail: efficiency > 70 ? "Hand shape stayed flexible in this line." : "Several actions narrowed useful tile options.", level: efficiency > 70 ? 1 : 2))
        notes.append(MJRAnalysisNote(title: "Discard risk", detail: risk > 60 ? "Late hand pressure suggests defensive review." : "Risk stayed controlled in the current record.", level: risk > 60 ? 3 : 1))
        return notes
    }

    private func riskWeight(for action: MJRAction) -> Int {
        switch action.type {
        case .riichi: return 22
        case .discard: return 10
        case .chi, .pon, .kan: return 7
        case .win: return 28
        default: return 3
        }
    }
}
