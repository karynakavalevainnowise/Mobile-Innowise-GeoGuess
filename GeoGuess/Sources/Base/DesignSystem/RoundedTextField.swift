import UIKit
import Combine

final class RoundedTextField: UITextField {

    struct Configuration {
        let placeholder: String
        let leftSystemIcon: String?
        let isSecure: Bool
        let autocapitalizationType: UITextAutocapitalizationType
        let autocorrectionType: UITextAutocorrectionType
        
        init(
            placeholder: String,
            leftSystemIcon: String? = nil,
            isSecure: Bool = false,
            autocapitalizationType: UITextAutocapitalizationType = .none,
            autocorrectionType: UITextAutocorrectionType = .no
        ) {
            self.placeholder = placeholder
            self.leftSystemIcon = leftSystemIcon
            self.isSecure = isSecure
            self.autocapitalizationType = autocapitalizationType
            self.autocorrectionType = autocorrectionType
        }
    }
    
    private var cancellables = Set<AnyCancellable>()

    func setValid(_ isValid: Bool) {
        layer.borderWidth  = 1
        layer.borderColor  = isValid ? UIColor.clear.cgColor : Constants.Colours.validationError.cgColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseStyle()
    }
    
    convenience init(configuration: Configuration) {
        self.init(frame: .zero)
        configure(with: configuration)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += Constants.Layout.textVerticalPadding
        return rect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= Constants.Layout.textVerticalPadding
        return rect
    }

    func configure(with config: Configuration) {
        placeholder = config.placeholder
        autocapitalizationType = config.autocapitalizationType
        autocorrectionType = config.autocorrectionType
        
        if let iconName = config.leftSystemIcon {
            configureLeftIcon(named: iconName)
        }
        
        if config.isSecure {
            isSecureTextEntry = true
            configureVisibilityToggle()
        }
    }

    private func setupBaseStyle() {
        borderStyle = .none
        backgroundColor = Constants.Colours.secondary
        layer.cornerRadius = Constants.Layout.cornerRadius
        font = .preferredFont(forTextStyle: .body)
        heightAnchor.constraint(equalToConstant: Constants.Layout.fieldHeight).isActive = true
    }

    private func configureLeftIcon(named systemName: String) {
        let icon = makeSideView(imageName: systemName)
        leftView = icon
        leftViewMode = .always
    }

    private func configureVisibilityToggle() {
        let button = UIButton(type: .system)
        button.tintColor = .secondaryLabel
        
        publisher(for: \.isSecureTextEntry)
            .sink { isSecure in
                let iconName = isSecure ? Constants.Icons.eyeSlash : Constants.Icons.eye
                button.setImage(UIImage(systemName: iconName), for: .normal)
            }
            .store(in: &cancellables)
            
        button.addTarget(self, action: #selector(toggleSecureText), for: .touchUpInside)

        rightView = button
        rightViewMode = .always
    }

    private func makeSideView(imageName: String) -> UIView {
        let imageView = UIImageView(image: UIImage(systemName: imageName))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .center
        let container = UIView(frame: CGRect(x: 0, y: 0, width: Constants.Layout.fieldHeight, height: Constants.Layout.fieldHeight))
        container.addSubview(imageView)
        imageView.frame = container.bounds
        return container
    }

    @objc private func toggleSecureText() {
        isSecureTextEntry.toggle()
    }
}

