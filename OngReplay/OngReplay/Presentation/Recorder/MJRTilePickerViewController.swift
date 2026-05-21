import UIKit

final class MJRTilePickerViewController: MJRBaseViewController {
    var onPick: ((MJRTile) -> Void)?

    private let selectedCode: String

    init(selectedCode: String) {
        self.selectedCode = selectedCode
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose Tile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
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
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: MJRTheme.Spacing.lg),
            stack.leadingAnchor.constraint(equalTo: scroll.frameLayoutGuide.leadingAnchor, constant: MJRTheme.Spacing.md),
            stack.trailingAnchor.constraint(equalTo: scroll.frameLayoutGuide.trailingAnchor, constant: -MJRTheme.Spacing.md),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -MJRTheme.Spacing.md * 2),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -MJRTheme.Spacing.xl)
        ])
        addSection("Characters", tiles: Array(MJRTile.all[0..<9]), to: stack)
        addSection("Dots", tiles: Array(MJRTile.all[9..<18]), to: stack)
        addSection("Bamboo", tiles: Array(MJRTile.all[18..<27]), to: stack)
        addSection("Honors", tiles: Array(MJRTile.all[27..<34]), to: stack)
    }

    private func addSection(_ title: String, tiles: [MJRTile], to stack: UIStackView) {
        let label = UILabel()
        label.text = title
        label.font = MJRTheme.Font.headline
        label.textColor = MJRTheme.Color.onSurface
        stack.addArrangedSubview(label)
        var row = UIStackView()
        for (index, tile) in tiles.enumerated() {
            if index % 5 == 0 {
                row = UIStackView()
                row.axis = .horizontal
                row.spacing = MJRTheme.Spacing.sm
                row.distribution = .fillEqually
                stack.addArrangedSubview(row)
            }
            row.addArrangedSubview(tileButton(tile))
        }
        while row.arrangedSubviews.count < 5 {
            let spacer = UIView()
            row.addArrangedSubview(spacer)
        }
    }

    private func tileButton(_ tile: MJRTile) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = tile.code == selectedCode ? MJRTheme.Color.primary.withAlphaComponent(0.28) : MJRTheme.Color.surfaceAlt
        button.layer.cornerRadius = MJRTheme.Radius.button
        button.layer.borderWidth = tile.code == selectedCode ? 1.5 : 0
        button.layer.borderColor = MJRTheme.Color.secondary.cgColor
        button.accessibilityLabel = tile.title
        button.addTarget(self, action: #selector(selectTile(_:)), for: .touchUpInside)
        button.tag = MJRTile.all.firstIndex(of: tile) ?? 0
        let tileView = MJRTileView(code: tile.code, size: CGSize(width: 38, height: 50))
        tileView.isUserInteractionEnabled = false
        button.addSubview(tileView)
        tileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 70),
            tileView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            tileView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        return button
    }

    @objc private func selectTile(_ sender: UIButton) {
        let tile = MJRTile.all[sender.tag]
        dismiss(animated: true) { [onPick] in onPick?(tile) }
    }

    @objc private func close() { dismiss(animated: true) }
}
