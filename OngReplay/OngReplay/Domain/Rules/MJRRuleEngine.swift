import Foundation

protocol MJRRuleEngine {
    var rule: MJRRule { get }
    var actionHelp: String { get }
    func scoreHint(for action: MJRAction) -> String
}

struct MJRJapaneseRule: MJRRuleEngine {
    let rule: MJRRule = .japanese
    let actionHelp = "Track riichi, calls, furiten risk, and turn order."
    func scoreHint(for action: MJRAction) -> String {
        action.type == .riichi ? "Riichi pressure increases discard risk." : "Estimate yaku after win."
    }
}

struct MJRChineseRule: MJRRuleEngine {
    let rule: MJRRule = .chinese
    let actionHelp = "Focus on fan value, exposure timing, and hand shape."
    func scoreHint(for action: MJRAction) -> String {
        action.type == .win ? "Review fan combinations and minimum score." : "Watch useful tile count."
    }
}

struct MJRHongKongRule: MJRRuleEngine {
    let rule: MJRRule = .hongKong
    let actionHelp = "Track faan threshold, risky honors, and late pushes."
    func scoreHint(for action: MJRAction) -> String {
        action.type == .pon ? "Open triplets can define a faan route." : "Balance speed and exposure."
    }
}

struct MJRRuleFactory {
    static func engine(for rule: MJRRule) -> MJRRuleEngine {
        switch rule {
        case .japanese: return MJRJapaneseRule()
        case .chinese: return MJRChineseRule()
        case .hongKong: return MJRHongKongRule()
        }
    }
}
