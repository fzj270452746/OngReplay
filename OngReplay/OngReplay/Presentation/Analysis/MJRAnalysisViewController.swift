import UIKit

final class MJRAnalysisViewController: MJRBaseViewController {
    private let replay: MJRReplay
    private let report: MJRAnalysisReport

    init(replay: MJRReplay) {
        self.replay = MJRReplayStore.shared.replay(id: replay.id) ?? replay
        self.report = MJRAnalyzer().report(for: self.replay)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Local Analysis"
        build()
    }

    private func build() {
        let scroll = UIScrollView()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = MJRTheme.Spacing.lg
        contentView.addSubview(scroll)
        scroll.pinEdges(to: contentView.safeAreaLayoutGuide)
        scroll.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: MJRTheme.Spacing.md),
            stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: MJRTheme.Spacing.md),
            stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -MJRTheme.Spacing.md),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -MJRTheme.Spacing.md * 2),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -MJRTheme.Spacing.xl)
        ])
        let metrics = UIStackView(arrangedSubviews: [
            MJRMetricCard(title: "Shanten", value: report.shantenText),
            MJRMetricCard(title: "Efficiency", value: "\(report.efficiency)%"),
            MJRMetricCard(title: "Risk", value: "\(report.risk)%")
        ])
        metrics.axis = .vertical
        metrics.spacing = MJRTheme.Spacing.md
        stack.addArrangedSubview(metrics)
        let line = MJRLineChartView()
        line.values = report.riskSeries
        line.backgroundColor = MJRTheme.Color.surface
        line.layer.cornerRadius = MJRTheme.Radius.card
        line.heightAnchor.constraint(equalToConstant: 150).isActive = true
        stack.addArrangedSubview(line)
        let strip = MJRRiskStripView()
        strip.values = report.riskSeries
        strip.heightAnchor.constraint(equalToConstant: 28).isActive = true
        stack.addArrangedSubview(strip)
        for note in report.notes { stack.addArrangedSubview(noteCard(note)) }
    }

    private func noteCard(_ note: MJRAnalysisNote) -> UIView {
        let card = MJRCardView()
        let title = UILabel()
        title.text = note.title
        title.font = MJRTheme.Font.headline
        title.textColor = note.level >= 3 ? MJRTheme.Color.riskHigh : MJRTheme.Color.onSurface
        let body = UILabel()
        body.text = note.detail
        body.font = MJRTheme.Font.body
        body.textColor = MJRTheme.Color.muted
        body.numberOfLines = 0
        let stack = UIStackView(arrangedSubviews: [title, body])
        stack.axis = .vertical
        stack.spacing = MJRTheme.Spacing.sm
        card.addSubview(stack)
        stack.pinEdges(to: card.layoutMarginsGuide)
        card.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
        return card
    }
}
