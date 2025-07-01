import UIKit

final class AuthorizationView: UIView {

    var onEmailChanged: ((String) -> Void)?
    var onPasswordChanged: ((String) -> Void)?
    var onSignIn: (() -> Void)?
    var onGuest: (() -> Void)?

    private let emailField = RoundedTextField(configuration: .init(
        placeholder: Constants.Strings.emailPlaceholder.localized,
        leftSystemIcon: Constants.Icons.envelope,
        autocapitalizationType: .none,
        autocorrectionType: .no
    ))

    private let passwordField = RoundedTextField(configuration: .init(
        placeholder: Constants.Strings.passwordPlaceholder.localized,
        leftSystemIcon: Constants.Icons.lock,
        isSecure: true
    ))

    private let signInButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = Constants.Strings.signIn.localized
        config.cornerStyle = .medium
        config.baseBackgroundColor = Constants.Colours.primary
        config.baseForegroundColor = .white
        let button = UIButton(configuration: config)
        button.titleLabel?.font = Constants.Typography.button
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()

    private let guestButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.continueGuest.localized, for: .normal)
        button.backgroundColor = Constants.Colours.secondary
        button.setTitleColor(Constants.Colours.primary, for: .normal)
        button.titleLabel?.font = Constants.Typography.button
        button.layer.cornerRadius = Constants.Layout.cornerRadius
        return button
    }()

    private let forgotPassButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.forgotPassword.localized, for: .normal)
        button.setTitleColor(Constants.Colours.primary, for: .normal)
        button.titleLabel?.font = Constants.Typography.link
        button.contentHorizontalAlignment = .trailing
        return button
    }()

    private let titleLabel: WavingTextLabel = {
        let label = WavingTextLabel()
        label.text = Constants.Strings.appTitle.localized
        label.font = Constants.Typography.title
        label.textColor = .label
        return label
    }()
    
    private let loadingView = LoadingIndicatorView()

    private lazy var formStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [
            emailField,
            passwordField,
            forgotPassButton,
            signInButton,
            guestButton
        ])
        s.axis = .vertical
        s.spacing = Constants.Layout.spacing
        s.setCustomSpacing(8, after: passwordField)
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
        addTargets()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        addSubviews(titleLabel, formStack, loadingView)
        [titleLabel, formStack, loadingView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.titleTopInset),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),

            formStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Layout.stackTopSpacing),
            formStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.horizontalPadding),
            formStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.horizontalPadding),

            signInButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight),
            guestButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight),
        ])
        
        loadingView.pinToEdges(of: self)
        loadingView.alpha = 0
    }

    private func addTargets() {
        emailField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        guestButton.addTarget(self, action: #selector(guestTapped), for: .touchUpInside)
    }

    @objc private func textFieldChanged(_ sender: UITextField) {
        if sender === emailField { onEmailChanged?(sender.text ?? "") }
        else if sender === passwordField { onPasswordChanged?(sender.text ?? "") }
    }
    @objc private func signInTapped() { onSignIn?() }
    @objc private func guestTapped() { onGuest?() }

    func setEmailValid(_ isValid: Bool) { emailField.setValid(isValid) }
    func setPasswordValid(_ isValid: Bool) { passwordField.setValid(isValid) }

    func setSignInEnabled(_ isEnabled: Bool) {
        signInButton.isEnabled = isEnabled
        signInButton.alpha = isEnabled ? 1.0 : 0.5
    }

    func setLoading(_ isLoading: Bool) {
        emailField.isEnabled = !isLoading
        passwordField.isEnabled = !isLoading
        guestButton.isEnabled = !isLoading
        forgotPassButton.isEnabled = !isLoading
        
        signInButton.alpha = isLoading ? 0.5 : (signInButton.isEnabled ? 1.0 : 0.5)

        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
        
        UIView.animate(withDuration: Constants.Animation.duration) {
            self.loadingView.alpha = isLoading ? 1.0 : 0.0
        }
    }
}
