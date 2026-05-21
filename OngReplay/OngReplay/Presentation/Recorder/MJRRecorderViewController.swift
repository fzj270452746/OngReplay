import UIKit

final class MJRRecorderViewController: MJRBaseViewController {
    private var replay: MJRReplay
    private let store = MJRReplayStore.shared
    private let board = MJRBoardView()
    private let actionStack = UIStackView()
    private let playerControl = UISegmentedControl()
    private let tileButton = MJRSecondaryButton(title: "Tile: 5m")
    private let noteField = UITextField()
    private var selectedTile = "5m"
    private var selectedAction: MJRActionType = .discard
    private var actionButtons: [UIButton] = []

    init(replay: MJRReplay) {
        self.replay = replay
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Recorder"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Replay", style: .plain, target: self, action: #selector(openReplay))
        build()
        render()
    }

    private func build() {
        let scroll = UIScrollView()
        let stack = UIStackView(arrangedSubviews: [board, formCard(), historyCard()])
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
    }

    private func formCard() -> UIView {
        let card = MJRCardView()
        for (index, player) in replay.players.enumerated() { playerControl.insertSegment(withTitle: player.wind.rawValue, at: index, animated: false) }
        playerControl.selectedSegmentIndex = 0
        noteField.placeholder = "Optional note"
        noteField.attributedPlaceholder = NSAttributedString(string: "Optional note", attributes: [.foregroundColor: MJRTheme.Color.muted])
        noteField.textColor = MJRTheme.Color.onSurface
        noteField.backgroundColor = MJRTheme.Color.surfaceAlt
        noteField.layer.cornerRadius = 10
        let add = MJRPrimaryButton(title: "Add Action")
        let branch = MJRSecondaryButton(title: "Add Branch Marker")
        tileButton.addTarget(self, action: #selector(pickTile), for: .touchUpInside)
        add.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        branch.addTarget(self, action: #selector(addBranch), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [playerControl, actionPicker(), tileButton, noteField, add, branch])
        stack.axis = .vertical
        stack.spacing = MJRTheme.Spacing.md
        card.addSubview(stack)
        stack.pinEdges(to: card.layoutMarginsGuide)
        card.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
        return card
    }

    private func actionPicker() -> UIView {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        actionStack.axis = .horizontal
        actionStack.spacing = MJRTheme.Spacing.sm
        scroll.addSubview(actionStack)
        actionStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionStack.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            actionStack.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            actionStack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            actionStack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),
            actionStack.heightAnchor.constraint(equalTo: scroll.frameLayoutGuide.heightAnchor),
            scroll.heightAnchor.constraint(equalToConstant: 44)
        ])
        actionButtons = MJRActionType.allCases.map { type in
            let button = MJRSecondaryButton(title: type.rawValue)
            button.tag = MJRActionType.allCases.firstIndex(of: type) ?? 0
            button.addTarget(self, action: #selector(selectAction(_:)), for: .touchUpInside)
            actionStack.addArrangedSubview(button)
            return button
        }
        updateActionButtons()
        return scroll
    }

    private func historyCard() -> UIView {
        let card = MJRCardView()
        card.tag = 909
        return card
    }

    private func render() {
        board.render(replay: replay)
        if let card = contentView.viewWithTag(909) as? MJRCardView {
            card.subviews.forEach { $0.removeFromSuperview() }
            let lines = replay.activeActions.suffix(8).map { "#\($0.turn) \($0.type.rawValue) \($0.tile)" }.joined(separator: "\n")
            let label = UILabel()
            label.text = lines.isEmpty ? "No actions yet." : lines
            label.numberOfLines = 0
            label.font = MJRTheme.Font.body
            label.textColor = MJRTheme.Color.muted
            card.addSubview(label)
            label.pinEdges(to: card.layoutMarginsGuide)
            card.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
        }
    }

    @objc private func addAction() {
        let player = replay.players[max(0, playerControl.selectedSegmentIndex)]
        replay.actions.append(MJRAction(replayId: replay.id, turn: replay.actions.count + 1, playerId: player.id, type: selectedAction, tile: selectedTile, note: noteField.text ?? ""))
        noteField.text = ""
        store.save(replay)
        render()
    }

    @objc private func selectAction(_ sender: UIButton) {
        selectedAction = MJRActionType.allCases[sender.tag]
        updateActionButtons()
    }

    private func updateActionButtons() {
        for button in actionButtons {
            let type = MJRActionType.allCases[button.tag]
            button.backgroundColor = type == selectedAction ? MJRTheme.Color.primary : MJRTheme.Color.surfaceAlt
            button.setTitleColor(type == selectedAction ? MJRTheme.Color.onSurface : MJRTheme.Color.secondary, for: .normal)
        }
    }

    @objc private func addBranch() {
        let branch = MJRBranch(id: UUID(), replayId: replay.id, parentActionId: replay.actions.last?.id, name: "Branch \(replay.branches.count + 1)", createdAt: Date())
        replay.branches.append(branch)
        let player = replay.players[max(0, playerControl.selectedSegmentIndex)]
        replay.actions.append(MJRAction(replayId: replay.id, turn: replay.actions.count + 1, playerId: player.id, type: .branch, note: branch.name, branchId: branch.id))
        store.save(replay)
        render()
    }

    @objc private func pickTile() {
        let picker = MJRTilePickerViewController(selectedCode: selectedTile)
        picker.onPick = { [weak self] tile in
            self?.selectedTile = tile.code
            self?.tileButton.setTitle("Tile: \(tile.title)", for: .normal)
        }
        let nav = UINavigationController(rootViewController: picker)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }

    @objc private func openReplay() { navigationController?.pushViewController(MJRReplayViewController(replay: replay), animated: true) }
}
