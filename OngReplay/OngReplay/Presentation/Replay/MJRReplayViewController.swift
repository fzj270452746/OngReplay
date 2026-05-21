import UIKit

final class MJRReplayViewController: MJRBaseViewController {
    private var replay: MJRReplay
    private let board = MJRBoardView()
    private let slider = UISlider()
    private let logLabel = UILabel()
    private var timer: Timer?
    private var index = 0

    init(replay: MJRReplay) {
        self.replay = MJRReplayStore.shared.replay(id: replay.id) ?? replay
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = replay.title
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Analyze", style: .plain, target: self, action: #selector(openAnalysis)),
            UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        ]
        build()
        render()
    }

    private func build() {
        let scroll = UIScrollView()
        let play = MJRPrimaryButton(title: "Play")
        let stats = MJRSecondaryButton(title: "Stats")
        let export = MJRSecondaryButton(title: "Share Image")
        let row = UIStackView(arrangedSubviews: [play, stats, export])
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = MJRTheme.Spacing.sm
        logLabel.numberOfLines = 0
        logLabel.font = MJRTheme.Font.body
        logLabel.textColor = MJRTheme.Color.muted
        slider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        play.addTarget(self, action: #selector(playback), for: .touchUpInside)
        stats.addTarget(self, action: #selector(openStats), for: .touchUpInside)
        export.addTarget(self, action: #selector(shareImage), for: .touchUpInside)
        let logCard = MJRCardView()
        logCard.addSubview(logLabel)
        logLabel.pinEdges(to: logCard.layoutMarginsGuide)
        logCard.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
        let stack = UIStackView(arrangedSubviews: [board, slider, row, logCard])
        stack.axis = .vertical
        stack.spacing = MJRTheme.Spacing.lg
        contentView.addSubview(scroll)
        scroll.pinEdges(to: contentView.safeAreaLayoutGuide)
        scroll.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            board.heightAnchor.constraint(greaterThanOrEqualToConstant: 330),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: MJRTheme.Spacing.md),
            stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: MJRTheme.Spacing.md),
            stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -MJRTheme.Spacing.md),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -MJRTheme.Spacing.md * 2),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -MJRTheme.Spacing.xl)
        ])
    }

    private func render() {
        let maxIndex = max(0, replay.activeActions.count - 1)
        index = min(index, maxIndex)
        slider.maximumValue = Float(maxIndex)
        slider.value = Float(index)
        board.render(replay: replay, through: index)
        let lines = replay.activeActions.prefix(index + 1).suffix(12).map { action -> String in
            let player = replay.players.first { $0.id == action.playerId }?.name ?? "Player"
            return "#\(action.turn) \(player): \(action.type.rawValue) \(action.tile) \(action.note)"
        }
        logLabel.text = lines.isEmpty ? "No actions recorded." : lines.joined(separator: "\n")
    }

    @objc private func sliderChanged() { index = Int(slider.value.rounded()); render() }

    @objc private func playback() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.55 / MJRSettingsStore().load().playbackSpeed, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.index >= max(0, self.replay.activeActions.count - 1) { timer.invalidate(); return }
            self.index += 1
            UIView.transition(with: self.board, duration: 0.22, options: .transitionCrossDissolve) { self.render() }
        }
    }

    @objc private func edit() { navigationController?.pushViewController(MJRRecorderViewController(replay: replay), animated: true) }
    @objc private func openAnalysis() { navigationController?.pushViewController(MJRAnalysisViewController(replay: replay), animated: true) }
    @objc private func openStats() { navigationController?.pushViewController(MJRStatsViewController(), animated: true) }

    @objc private func shareImage() {
        do {
            let url = try MJRExporter().exportImage(from: view, name: replay.title.replacingOccurrences(of: " ", with: "-"))
            let sheet = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            sheet.popoverPresentationController?.sourceView = view
            sheet.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 1, height: 1)
            present(sheet, animated: true)
        } catch { showError(error.localizedDescription) }
    }
}
