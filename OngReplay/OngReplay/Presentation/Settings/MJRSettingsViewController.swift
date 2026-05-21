import UIKit

final class MJRSettingsViewController: MJRBaseViewController {
    private let settingsStore = MJRSettingsStore()
    private var settings: MJRSettings
    private let ruleControl = UISegmentedControl(items: MJRRule.allCases.map { $0.rawValue })
    private let speedSlider = UISlider()
    private let speedLabel = UILabel()

    init() {
        self.settings = settingsStore.load()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        build()
    }

    private func build() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = MJRTheme.Spacing.lg
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: MJRTheme.Spacing.lg),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: MJRTheme.Spacing.md),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -MJRTheme.Spacing.md)
        ])
        ruleControl.selectedSegmentIndex = MJRRule.allCases.firstIndex(of: settings.defaultRule) ?? 0
        ruleControl.addTarget(self, action: #selector(save), for: .valueChanged)
        speedSlider.minimumValue = 0.5
        speedSlider.maximumValue = 2.0
        speedSlider.value = Float(settings.playbackSpeed)
        speedSlider.addTarget(self, action: #selector(save), for: .valueChanged)
        speedLabel.font = MJRTheme.Font.body
        speedLabel.textColor = MJRTheme.Color.onSurface
        let reset = MJRSecondaryButton(title: "Restore Sample Replays")
        reset.addTarget(self, action: #selector(resetSamples), for: .touchUpInside)
        stack.addArrangedSubview(card(title: "Default Rule", body: "Choose the rule preset for new replays.", extra: ruleControl))
        stack.addArrangedSubview(card(title: "Playback Speed", body: "Controls timeline auto-play speed.", extra: speedSlider))
        stack.addArrangedSubview(reset)
        stack.addArrangedSubview(about())
        updateSpeedLabel()
    }

    private func card(title: String, body: String, extra: UIView) -> UIView {
        let card = MJRCardView()
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = MJRTheme.Font.headline
        titleLabel.textColor = MJRTheme.Color.onSurface
        let bodyLabel = UILabel()
        bodyLabel.text = body
        bodyLabel.font = MJRTheme.Font.body
        bodyLabel.textColor = MJRTheme.Color.muted
        bodyLabel.numberOfLines = 0
        let views = title == "Playback Speed" ? [titleLabel, bodyLabel, speedLabel, extra] : [titleLabel, bodyLabel, extra]
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .vertical
        stack.spacing = MJRTheme.Spacing.md
        card.addSubview(stack)
        stack.pinEdges(to: card.layoutMarginsGuide)
        card.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
        return card
    }

    private func about() -> UILabel {
        let label = UILabel()
        label.text = "Mahjong Replay works fully offline. Analysis is a local estimate for study, not a final scoring authority."
        label.font = MJRTheme.Font.caption
        label.textColor = MJRTheme.Color.muted
        label.numberOfLines = 0
        return label
    }

    private func updateSpeedLabel() { speedLabel.text = String(format: "%.1fx", settings.playbackSpeed) }

    @objc private func save() {
        settings.defaultRule = MJRRule.allCases[max(0, ruleControl.selectedSegmentIndex)]
        settings.playbackSpeed = Double(speedSlider.value)
        settingsStore.save(settings)
        updateSpeedLabel()
    }

    @objc private func resetSamples() {
        MJRReplayStore.shared.resetSamples()
        let alert = UIAlertController(title: "Samples restored", message: "Sample replays were added to your library.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
