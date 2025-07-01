import UIKit

final class HomeView: UIView {
    var onStartQuiz: (() -> Void)?
    var onBrowseCountries: (() -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Strings.homeTitle.localized
        label.font = Constants.Typography.title
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.Strings.homeSubtitle.localized
        label.font = Constants.Typography.link
        label.textColor = Constants.Colours.tertiaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let startQuizButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.homeStartQuiz.localized, for: .normal)
        button.titleLabel?.font = Constants.Typography.button
        button.backgroundColor = Constants.Colours.primary
        button.setTitleColor(Constants.Colours.primaryButtonText, for: .normal)
        button.layer.cornerRadius = Constants.Layout.cornerRadius
        return button
    }()

    private let browseCountriesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.homeBrowseCountries.localized, for: .normal)
        button.titleLabel?.font = Constants.Typography.button
        button.backgroundColor = Constants.Colours.secondary
        button.setTitleColor(Constants.Colours.primary, for: .normal)
        button.layer.cornerRadius = Constants.Layout.cornerRadius
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            startQuizButton,
            browseCountriesButton
        ])
        stack.axis = .vertical
        stack.spacing = Constants.Layout.spacing
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
        addTargets()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.horizontalPadding),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.horizontalPadding),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            startQuizButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight),
            browseCountriesButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight)
        ])
    }

    private func addTargets() {
        startQuizButton.addTarget(self, action: #selector(startQuizTapped), for: .touchUpInside)
        browseCountriesButton.addTarget(self, action: #selector(browseCountriesTapped), for: .touchUpInside)
    }

    @objc private func startQuizTapped() {
        onStartQuiz?()
    }

    @objc private func browseCountriesTapped() {
        onBrowseCountries?()
    }
}
