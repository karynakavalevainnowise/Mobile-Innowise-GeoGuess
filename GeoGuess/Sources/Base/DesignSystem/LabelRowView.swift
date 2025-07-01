import UIKit

struct LabelRowViewConfiguration: UIContentConfiguration {
    var title: String
    var value: String
    var titleFont: UIFont = Constants.Typography.link
    var valueFont: UIFont = Constants.Typography.link.withSize(15)
    var titleColor: UIColor = .secondaryLabel
    var valueColor: UIColor = .label
    var showsDivider: Bool = true

    func makeContentView() -> UIView & UIContentView {
        return LabelRowView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> LabelRowViewConfiguration {
        // We can make adjustments based on the state (e.g., isHighlighted) if needed.
        // For now, we return self.
        return self
    }
}

final class LabelRowView: UIView, UIContentView {

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let divider = UIView()
    private lazy var rowStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
    private lazy var mainStack = UIStackView(arrangedSubviews: [rowStack, divider])

    private var _configuration: LabelRowViewConfiguration!
    var configuration: UIContentConfiguration {
        get { _configuration }
        set {
            guard let newConfig = newValue as? LabelRowViewConfiguration else { return }
            apply(configuration: newConfig)
        }
    }

    init(configuration: LabelRowViewConfiguration) {
        super.init(frame: .zero)
        setupViews()
        apply(configuration: configuration)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        rowStack.axis = .horizontal
        rowStack.distribution = .fill
        rowStack.alignment = .center
        rowStack.spacing = Constants.Layout.textVerticalPadding
        
        mainStack.axis = .vertical
        mainStack.spacing = Constants.Layout.textVerticalPadding

        valueLabel.textAlignment = .right
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)
        divider.backgroundColor = .systemGray5

        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.textVerticalPadding),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.spacing),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.spacing),
            divider.heightAnchor.constraint(equalToConstant: Constants.Layout.dividerHeight)
        ])
    }

    private func apply(configuration: LabelRowViewConfiguration) {
        guard _configuration != configuration else { return }
        _configuration = configuration
        
        titleLabel.text = configuration.title
        titleLabel.font = configuration.titleFont
        titleLabel.textColor = configuration.titleColor
        
        valueLabel.text = configuration.value
        valueLabel.font = configuration.valueFont
        valueLabel.textColor = configuration.valueColor
        
        divider.isHidden = !configuration.showsDivider
    }
}

extension LabelRowViewConfiguration: Equatable {
    static func == (lhs: LabelRowViewConfiguration, rhs: LabelRowViewConfiguration) -> Bool {
        return lhs.title == rhs.title &&
               lhs.value == rhs.value &&
               lhs.titleFont == rhs.titleFont &&
               lhs.valueFont == rhs.valueFont &&
               lhs.titleColor == rhs.titleColor &&
               lhs.valueColor == rhs.valueColor &&
               lhs.showsDivider == rhs.showsDivider
    }
}

