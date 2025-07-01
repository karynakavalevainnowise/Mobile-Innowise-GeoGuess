import Lottie
import UIKit

final class SplashView: UIView {

    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: Constants.Animation.splashName)
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .playOnce
        return animation
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Strings.splashDescription.localized
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = .zero
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        animationView.play()
    }

    private func setupLayout() {
        backgroundColor = .systemBackground
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(animationView, descriptionLabel)

        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: Constants.Layout.animWidthRatio
            ),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor),

            descriptionLabel.topAnchor.constraint(
                equalTo: animationView.bottomAnchor,
                constant: Constants.Layout.spacing
            ),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
