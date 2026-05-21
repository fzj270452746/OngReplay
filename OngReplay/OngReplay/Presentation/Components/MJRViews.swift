import UIKit

class MJRCardView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = MJRTheme.Color.surface
        layer.cornerRadius = MJRTheme.Radius.card
        layer.borderWidth = 1
        layer.borderColor = MJRTheme.Color.secondary.withAlphaComponent(0.16).cgColor
    }

    required init?(coder: NSCoder) { nil }
}

final class MJRPrimaryButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(MJRTheme.Color.onSurface, for: .normal)
        titleLabel?.font = MJRTheme.Font.bodyBold
        backgroundColor = MJRTheme.Color.primary
        layer.cornerRadius = MJRTheme.Radius.button
        contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    }

    required init?(coder: NSCoder) { nil }
}

final class MJRSecondaryButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(MJRTheme.Color.secondary, for: .normal)
        titleLabel?.font = MJRTheme.Font.bodyBold
        backgroundColor = MJRTheme.Color.surfaceAlt
        layer.cornerRadius = MJRTheme.Radius.button
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
    }

    required init?(coder: NSCoder) { nil }
}

final class MJRTileView: UIView {
    private let tile: MJRTile
    private let tileSize: CGSize

    init(code: String, size: CGSize = CGSize(width: 40, height: 52)) {
        tile = MJRTile.find(code)
        tileSize = size
        super.init(frame: .zero)
        isOpaque = false
        backgroundColor = .clear
        accessibilityLabel = tile.title
        setContentHuggingPriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    required init?(coder: NSCoder) { nil }

    override var intrinsicContentSize: CGSize { tileSize }

    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        let body = rect.insetBy(dx: 1.5, dy: 1.5)
        drawBody(in: body)
        let face = body.insetBy(dx: body.width * 0.18, dy: body.height * 0.16)
        switch tile.kind {
        case .man(let rank): drawMan(rank, in: face)
        case .pin(let rank): drawPin(rank, in: face)
        case .sou(let rank): drawSou(rank, in: face)
        case .wind(let name): drawHonor(String(name.prefix(1)), color: UIColor(hex: 0x202830), in: face)
        case .dragon(let name): drawDragon(name, in: face)
        case .unknown: drawHonor(tile.title, color: UIColor(hex: 0x202830), in: face)
        }
    }

    private func drawBody(in rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let path = UIBezierPath(roundedRect: rect, cornerRadius: MJRTheme.Radius.tile)
        context.saveGState()
        context.setShadow(offset: CGSize(width: 0, height: 2), blur: 3, color: UIColor.black.withAlphaComponent(0.25).cgColor)
        UIColor(hex: 0xF7EEDD).setFill()
        path.fill()
        context.restoreGState()

        UIColor(hex: 0xD1BFA7).setStroke()
        path.lineWidth = 1
        path.stroke()
        let top = UIBezierPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerRadius: max(2, MJRTheme.Radius.tile - 2))
        UIColor.white.withAlphaComponent(0.32).setStroke()
        top.lineWidth = 0.7
        top.stroke()
    }

    private func drawMan(_ rank: Int, in rect: CGRect) {
        drawText("\(rank)", color: rank == 5 ? UIColor(hex: 0xC43E32) : UIColor(hex: 0x202830), fontSize: rect.height * 0.45, rect: CGRect(x: rect.minX, y: rect.minY - 1, width: rect.width, height: rect.height * 0.46))
        drawText("萬", color: UIColor(hex: 0xB92D2B), fontSize: rect.height * 0.36, rect: CGRect(x: rect.minX - 1, y: rect.midY - 2, width: rect.width + 2, height: rect.height * 0.44))
    }

    private func drawPin(_ rank: Int, in rect: CGRect) {
        let points = pipPoints(rank, in: rect)
        for (index, point) in points.enumerated() {
            let color = index % 3 == 0 ? UIColor(hex: 0x2367A5) : (index % 3 == 1 ? UIColor(hex: 0xC43E32) : UIColor(hex: 0x2B8A50))
            drawCircle(center: point, radius: min(rect.width, rect.height) * 0.115, color: color)
        }
    }

    private func drawSou(_ rank: Int, in rect: CGRect) {
        if rank == 1 {
            drawText("竹", color: UIColor(hex: 0x257D49), fontSize: rect.height * 0.54, rect: rect)
            return
        }
        for point in pipPoints(rank, in: rect) {
            drawBamboo(center: point, size: min(rect.width, rect.height) * 0.18)
        }
    }

    private func drawDragon(_ name: String, in rect: CGRect) {
        if name == "White" {
            let box = UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: rect.height * 0.2), cornerRadius: 3)
            UIColor(hex: 0x4F6A86).setStroke()
            box.lineWidth = 2
            box.stroke()
            return
        }
        let text = name == "Green" ? "發" : "中"
        let color = name == "Green" ? UIColor(hex: 0x258348) : UIColor(hex: 0xC43E32)
        drawHonor(text, color: color, in: rect)
    }

    private func drawHonor(_ text: String, color: UIColor, in rect: CGRect) {
        drawText(text, color: color, fontSize: text.count > 1 ? rect.height * 0.28 : rect.height * 0.58, rect: rect)
    }

    private func drawText(_ text: String, color: UIColor, fontSize: CGFloat, rect: CGRect) {
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let font = UIFont.systemFont(ofSize: fontSize, weight: .heavy)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: color, .paragraphStyle: style]
        let size = text.boundingRect(with: rect.size, options: [.usesLineFragmentOrigin], attributes: attributes, context: nil).size
        let target = CGRect(x: rect.minX, y: rect.midY - size.height / 2, width: rect.width, height: size.height)
        text.draw(in: target, withAttributes: attributes)
    }

    private func drawCircle(center: CGPoint, radius: CGFloat, color: UIColor) {
        let outer = UIBezierPath(ovalIn: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
        color.setStroke()
        outer.lineWidth = 1.5
        outer.stroke()
        let inner = UIBezierPath(ovalIn: CGRect(x: center.x - radius * 0.45, y: center.y - radius * 0.45, width: radius * 0.9, height: radius * 0.9))
        color.withAlphaComponent(0.55).setFill()
        inner.fill()
    }

    private func drawBamboo(center: CGPoint, size: CGFloat) {
        UIColor(hex: 0x257D49).setStroke()
        let path = UIBezierPath()
        path.lineWidth = max(1.2, size * 0.22)
        path.lineCapStyle = .round
        path.move(to: CGPoint(x: center.x, y: center.y - size))
        path.addLine(to: CGPoint(x: center.x, y: center.y + size))
        path.stroke()
        UIColor(hex: 0xC43E32).setStroke()
        let band = UIBezierPath()
        band.lineWidth = max(0.8, size * 0.14)
        band.move(to: CGPoint(x: center.x - size * 0.42, y: center.y))
        band.addLine(to: CGPoint(x: center.x + size * 0.42, y: center.y))
        band.stroke()
    }

    private func pipPoints(_ count: Int, in rect: CGRect) -> [CGPoint] {
        let xs = [rect.minX + rect.width * 0.22, rect.midX, rect.maxX - rect.width * 0.22]
        let ys = [rect.minY + rect.height * 0.18, rect.minY + rect.height * 0.38, rect.midY, rect.maxY - rect.height * 0.38, rect.maxY - rect.height * 0.18]
        switch count {
        case 1: return [CGPoint(x: xs[1], y: rect.midY)]
        case 2: return [CGPoint(x: xs[1], y: ys[1]), CGPoint(x: xs[1], y: ys[3])]
        case 3: return [CGPoint(x: xs[1], y: ys[0]), CGPoint(x: xs[1], y: rect.midY), CGPoint(x: xs[1], y: ys[4])]
        case 4: return [CGPoint(x: xs[0], y: ys[1]), CGPoint(x: xs[2], y: ys[1]), CGPoint(x: xs[0], y: ys[3]), CGPoint(x: xs[2], y: ys[3])]
        case 5: return [CGPoint(x: xs[0], y: ys[1]), CGPoint(x: xs[2], y: ys[1]), CGPoint(x: xs[1], y: rect.midY), CGPoint(x: xs[0], y: ys[3]), CGPoint(x: xs[2], y: ys[3])]
        case 6: return [CGPoint(x: xs[0], y: ys[0]), CGPoint(x: xs[2], y: ys[0]), CGPoint(x: xs[0], y: rect.midY), CGPoint(x: xs[2], y: rect.midY), CGPoint(x: xs[0], y: ys[4]), CGPoint(x: xs[2], y: ys[4])]
        case 7: return pipPoints(6, in: rect) + [CGPoint(x: xs[1], y: rect.midY)]
        case 8: return [CGPoint(x: xs[0], y: ys[0]), CGPoint(x: xs[2], y: ys[0]), CGPoint(x: xs[0], y: ys[1]), CGPoint(x: xs[2], y: ys[1]), CGPoint(x: xs[0], y: ys[3]), CGPoint(x: xs[2], y: ys[3]), CGPoint(x: xs[0], y: ys[4]), CGPoint(x: xs[2], y: ys[4])]
        default: return pipPoints(8, in: rect) + [CGPoint(x: xs[1], y: rect.midY)]
        }
    }
}

final class MJRMetricCard: MJRCardView {
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()

    init(title: String, value: String) {
        super.init(frame: .zero)
        let stack = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stack.axis = .vertical
        stack.spacing = 3
        addSubview(stack)
        stack.pinEdges(to: layoutMarginsGuide)
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
        valueLabel.text = value
        valueLabel.font = MJRTheme.Font.headline
        valueLabel.textColor = MJRTheme.Color.onSurface
        titleLabel.text = title
        titleLabel.font = MJRTheme.Font.caption
        titleLabel.textColor = MJRTheme.Color.muted
    }

    required init?(coder: NSCoder) { nil }
}
