import UIKit

final class MJRLineChartView: UIView {
    var values: [CGFloat] = [] { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        guard values.count > 1, let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(MJRTheme.Color.accent.cgColor)
        context.setLineWidth(3)
        let path = UIBezierPath()
        for (index, value) in values.enumerated() {
            let x = rect.minX + CGFloat(index) / CGFloat(values.count - 1) * rect.width
            let y = rect.maxY - min(1, max(0, value)) * rect.height
            index == 0 ? path.move(to: CGPoint(x: x, y: y)) : path.addLine(to: CGPoint(x: x, y: y))
        }
        path.stroke()
        MJRTheme.Color.secondary.withAlphaComponent(0.14).setFill()
        UIRectFill(CGRect(x: 0, y: rect.maxY - 1, width: rect.width, height: 1))
    }
}

final class MJRRiskStripView: UIView {
    var values: [CGFloat] = [] { didSet { setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        guard !values.isEmpty else { return }
        let width = rect.width / CGFloat(values.count)
        for (index, value) in values.enumerated() {
            color(for: value).setFill()
            let bar = CGRect(x: CGFloat(index) * width, y: 0, width: max(1, width - 1), height: rect.height)
            UIBezierPath(roundedRect: bar, cornerRadius: 3).fill()
        }
    }

    private func color(for value: CGFloat) -> UIColor {
        if value > 0.7 { return MJRTheme.Color.riskHigh }
        if value > 0.42 { return MJRTheme.Color.riskMid }
        return MJRTheme.Color.riskLow
    }
}
