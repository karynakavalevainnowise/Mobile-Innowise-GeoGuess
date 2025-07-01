import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            guard view.superview !== self else { return }
            addSubview(view)
        }
    }
}

extension UIView {
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
}

extension UIView {
    func addGradientBackground() {
        guard !subviews.contains(where: { $0 is GradientBackgroundView }) else {
            return
        }
        
        let backgroundView = GradientBackgroundView()
        insertSubview(backgroundView, at: 0)
        backgroundView.pinToEdges(of: self)
    }
}
