import UIKit

extension UIView {
    func pinEdges(to guide: UILayoutGuide, inset: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: inset),
            trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -inset),
            topAnchor.constraint(equalTo: guide.topAnchor, constant: inset),
            bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -inset)
        ])
    }

    func constrainReadableWidth(max: CGFloat = 520) {
        let constraint = widthAnchor.constraint(lessThanOrEqualToConstant: max)
        constraint.priority = .required
        constraint.isActive = true
    }
}
