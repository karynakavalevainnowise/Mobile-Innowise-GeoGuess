import UIKit

final class WavingTextLabel: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    var text: String? {
        didSet {
            setupLabels()
        }
    }
    
    var font: UIFont = Constants.Typography.title
    var textColor: UIColor = .label

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        stackView.pinToEdges(of: self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        startAnimation()
    }

    private func setupLabels() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard let text = text else { return }
        
        for character in text {
            let label = UILabel()
            label.text = String(character)
            label.font = font
            label.textColor = textColor
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
    }
    
    private func startAnimation() {
        for (index, label) in stackView.arrangedSubviews.enumerated() {
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.toValue = Constants.Animation.Wave.translationY
            animation.duration = Constants.Animation.Wave.duration
            animation.autoreverses = true
            animation.repeatCount = .infinity
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.beginTime = CACurrentMediaTime() + (Constants.Animation.Wave.delay * Double(index))
            label.layer.add(animation, forKey: "wave-\(index)")
        }
    }
} 
