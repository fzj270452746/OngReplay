import UIKit

final class MJRBoardView: MJRCardView {
    private let stack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        stack.axis = .vertical
        stack.spacing = MJRTheme.Spacing.md
        addSubview(stack)
        stack.pinEdges(to: layoutMarginsGuide)
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
    }

    required init?(coder: NSCoder) { nil }

    func render(replay: MJRReplay, through index: Int? = nil) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let actions = replay.activeActions
        let visible = Array(actions.prefix((index ?? actions.count - 1) + 1))
        for player in replay.players {
            stack.addArrangedSubview(row(player: player, actions: visible.filter { $0.playerId == player.id }))
        }
    }

    private func row(player: MJRPlayer, actions: [MJRAction]) -> UIView {
        let container = UIView()
        let name = UILabel()
        name.text = "\(player.wind.rawValue)  \(player.name)"
        name.font = MJRTheme.Font.caption
        name.textColor = MJRTheme.Color.muted
        let river = UIStackView()
        river.axis = .horizontal
        river.spacing = 4
        river.alignment = .center
        river.isLayoutMarginsRelativeArrangement = true
        river.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 1, bottom: 0, trailing: 1)
        for action in actions.suffix(8) {
            if action.type == .discard || action.type == .draw || action.type == .win || action.type == .pon || action.type == .chi || action.type == .kan {
                river.addArrangedSubview(MJRTileView(code: action.tile.isEmpty ? action.type.rawValue : action.tile, size: CGSize(width: 31, height: 41)))
            }
        }
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.addSubview(river)
        river.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            river.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            river.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            river.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            river.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            river.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor),
            scroll.heightAnchor.constraint(equalToConstant: 43)
        ])
        let inner = UIStackView(arrangedSubviews: [name, scroll])
        inner.axis = .vertical
        inner.spacing = 5
        container.addSubview(inner)
        inner.pinEdges(to: container.layoutMarginsGuide)
        container.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0)
        return container
    }
}
