import UIKit

final class EmptyStateView: UIView {
    private let imageView = UIImageView()
    private let messageLabel = UILabel()

    init(image: UIImage?, message: String) {
        super.init(frame: .zero)
        setup(image: image, message: message)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(image: nil, message: "")
    }

    private func setup(image: UIImage?, message: String) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Colours.primary
        imageView.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.textColor = Constants.Colours.tertiaryText
        messageLabel.font = Constants.Typography.button
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(messageLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),

            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ])
    }

    func setMessage(_ message: String) {
        messageLabel.text = message
    }

    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
} 