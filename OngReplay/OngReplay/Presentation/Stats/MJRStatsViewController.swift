import UIKit

final class MJRStatsViewController: MJRBaseViewController {
    private let store = MJRReplayStore.shared
    private let analyzer = MJRAnalyzer()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statistics"
        build()
    }

    private func build() {
        let replays = store.all()
        let stats = analyzer.stats(for: replays)
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
        let row1 = UIStackView(arrangedSubviews: [MJRMetricCard(title: "Total", value: "\(stats.total)"), MJRMetricCard(title: "Win Rate", value: String(format: "%.0f%%", stats.winRate * 100))])
        let row2 = UIStackView(arrangedSubviews: [MJRMetricCard(title: "Riichi", value: "\(stats.riichi)"), MJRMetricCard(title: "Calls", value: "\(stats.calls)")])
        [row1, row2].forEach { row in row.axis = .horizontal; row.spacing = MJRTheme.Spacing.md; row.distribution = .fillEqually; stack.addArrangedSubview(row) }
        let chart = MJRLineChartView()
        chart.values = replays.map { CGFloat(analyzer.report(for: $0).risk) / 100.0 }
        chart.backgroundColor = MJRTheme.Color.surface
        chart.layer.cornerRadius = MJRTheme.Radius.card
        chart.heightAnchor.constraint(equalToConstant: 180).isActive = true
        stack.addArrangedSubview(chart)
        let summary = UILabel()
        summary.numberOfLines = 0
        summary.font = MJRTheme.Font.body
        summary.textColor = MJRTheme.Color.muted
        summary.text = "Common focus: review late discards after riichi, compare open-hand speed, and tag branch points before risky pushes."
        stack.addArrangedSubview(summary)
    }
}
