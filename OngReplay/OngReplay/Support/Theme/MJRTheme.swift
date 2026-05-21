import UIKit

enum MJRTheme {
    enum Color {
        static let primary = UIColor(hex: 0x8B3A2E)
        static let secondary = UIColor(hex: 0xD6A85C)
        static let background = UIColor(hex: 0x15100D)
        static let surface = UIColor(hex: 0x241A15)
        static let surfaceAlt = UIColor(hex: 0x33251D)
        static let onSurface = UIColor(hex: 0xF6EEE4)
        static let muted = UIColor(hex: 0xB7A89A)
        static let accent = UIColor(hex: 0xE66F35)
        static let riskLow = UIColor(hex: 0xE3C66A)
        static let riskMid = UIColor(hex: 0xE68635)
        static let riskHigh = UIColor(hex: 0xD94A3A)
    }

    enum Font {
        static let largeTitle = UIFont.systemFont(ofSize: 32, weight: .heavy)
        static let title = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let headline = UIFont.systemFont(ofSize: 18, weight: .bold)
        static let body = UIFont.systemFont(ofSize: 15, weight: .regular)
        static let bodyBold = UIFont.systemFont(ofSize: 15, weight: .semibold)
        static let caption = UIFont.systemFont(ofSize: 12, weight: .regular)
    }

    enum Spacing {
        static let sm: CGFloat = 6
        static let md: CGFloat = 12
        static let lg: CGFloat = 18
        static let xl: CGFloat = 30
    }

    enum Radius {
        static let card: CGFloat = 18
        static let button: CGFloat = 14
        static let tile: CGFloat = 8
    }
}
