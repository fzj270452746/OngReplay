import UIKit

final class MJRExporter {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    func exportJSON(_ replay: MJRReplay) throws -> URL {
        let data = try encoder.encode(replay)
        let name = replay.title.replacingOccurrences(of: " ", with: "-") + ".json"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name)
        try data.write(to: url, options: .atomic)
        return url
    }

    func importJSON(from url: URL) throws -> MJRReplay {
        let data = try Data(contentsOf: url)
        return try decoder.decode(MJRReplay.self, from: data)
    }

    func exportImage(from view: UIView, name: String) throws -> URL {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { context in
            view.layer.render(in: context.cgContext)
        }
        guard let data = image.pngData() else { throw NSError(domain: "MJRExporter", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to render image"]) }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name + ".png")
        try data.write(to: url, options: .atomic)
        return url
    }
}
