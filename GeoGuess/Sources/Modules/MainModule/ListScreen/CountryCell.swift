import UIKit

final class CountryCell: UITableViewCell {
    static let reuseID = "CountryCell"

    private let flagImageView: LoadingImageView = {
        let imageView = LoadingImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.Layout.cornerRadius / 2
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = Constants.Cell.Border.width
        imageView.layer.borderColor = Constants.Colours.cellBorder
        imageView.layer.shadowColor = Constants.Colours.shadow
        imageView.layer.shadowOpacity = Constants.Cell.Shadow.opacity
        imageView.layer.shadowOffset = Constants.Cell.Shadow.offset
        imageView.layer.shadowRadius = Constants.Cell.Shadow.radius
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Typography.button
        label.numberOfLines = 1
        return label
    }()
    
    private let continentLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Typography.link
        label.textColor = .secondaryLabel
        return label
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = Constants.Layout.spacing
        stack.alignment = .center
        return stack
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.Cell.textStackSpacing
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        flagImageView.layer.shadowPath = UIBezierPath(roundedRect: flagImageView.bounds, cornerRadius: flagImageView.layer.cornerRadius).cgPath
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func configure(with country: CountryModel) {
        nameLabel.text = country.name
        continentLabel.text = country.continent
        flagImageView.loadImage(from: country.flagURL)
    }

    private func setupLayout() {
        contentView.addSubview(mainStackView)
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        textStackView.addArrangedSubview(nameLabel)
        textStackView.addArrangedSubview(continentLabel)
        
        mainStackView.addArrangedSubview(flagImageView)
        mainStackView.addArrangedSubview(textStackView)

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Layout.cornerRadius),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Layout.cornerRadius),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Layout.spacing),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Layout.spacing),
            flagImageView.widthAnchor.constraint(equalToConstant: Constants.Cell.flagWidth),
            flagImageView.heightAnchor.constraint(equalToConstant: Constants.Cell.flagHeight)
        ])
    }
}
