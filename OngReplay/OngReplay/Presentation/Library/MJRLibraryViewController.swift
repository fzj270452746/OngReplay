import UIKit
import UniformTypeIdentifiers

final class MJRLibraryViewController: MJRBaseViewController, UITableViewDataSource, UITableViewDelegate, UIDocumentPickerDelegate {
    private let store = MJRReplayStore.shared
    private let exporter = MJRExporter()
    private let table = UITableView(frame: .zero, style: .plain)
    private var replays: [MJRReplay] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Replay Library"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Import", style: .plain, target: self, action: #selector(importReplay)),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReplay))
        ]
        build()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }

    private func build() {
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        contentView.addSubview(table)
        table.pinEdges(to: contentView.safeAreaLayoutGuide, inset: MJRTheme.Spacing.sm)
    }

    private func reload() {
        replays = store.all()
        table.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { replays.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let replay = replays[indexPath.row]
        cell.backgroundColor = .clear
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.textColor = MJRTheme.Color.onSurface
        cell.textLabel?.font = MJRTheme.Font.bodyBold
        cell.textLabel?.text = "\(replay.title)\n\(replay.rule.rawValue) • \(replay.actions.count) actions"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(MJRReplayViewController(replay: replays[indexPath.row]), animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let replay = replays[indexPath.row]
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, done in
            self?.store.delete(id: replay.id)
            self?.reload()
            done(true)
        }
        let export = UIContextualAction(style: .normal, title: "Export") { [weak self] _, _, done in
            self?.share(replay)
            done(true)
        }
        export.backgroundColor = MJRTheme.Color.primary
        return UISwipeActionsConfiguration(actions: [delete, export])
    }

    private func share(_ replay: MJRReplay) {
        do {
            let url = try exporter.exportJSON(replay)
            let sheet = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            sheet.popoverPresentationController?.sourceView = view
            sheet.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 1, height: 1)
            present(sheet, animated: true)
        } catch { showError(error.localizedDescription) }
    }

    @objc private func addReplay() {
        let replay = MJRSeed.emptyReplay(title: "Replay \(replays.count + 1)", rule: MJRSettingsStore().load().defaultRule)
        store.save(replay)
        navigationController?.pushViewController(MJRRecorderViewController(replay: replay), animated: true)
    }

    @objc private func importReplay() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.json], asCopy: true)
        picker.delegate = self
        present(picker, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        do { store.save(try exporter.importJSON(from: url)); reload() } catch { showError(error.localizedDescription) }
    }
}
