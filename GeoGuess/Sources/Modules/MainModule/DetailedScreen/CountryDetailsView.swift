import UIKit

final class CountryDetailsView: UIView {

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colours.secondary
        view.layer.cornerRadius = Constants.Detail.cardCornerRadius
        view.layer.shadowColor = Constants.Colours.shadow
        view.layer.shadowOpacity = Constants.Detail.Shadow.opacity
        view.layer.shadowRadius = Constants.Detail.Shadow.radius
        view.layer.shadowOffset = Constants.Detail.Shadow.offset
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let flagImageView: LoadingImageView = {
        let imageView = LoadingImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.Layout.cornerRadius
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = Constants.Cell.Border.width
        imageView.layer.borderColor = Constants.Colours.cellBorder
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Typography.title
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Constants.Detail.infoStackSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let loadingView = LoadingIndicatorView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupView()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(cardView)
        cardView.addSubview(flagImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(infoStack)
        addSubview(loadingView)
    }

    private func setupConstraints() {
        loadingView.pinToEdges(of: self)
        
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Layout.horizontalPadding),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Layout.horizontalPadding),

            flagImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Constants.Layout.spacing),
            flagImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.Layout.spacing),
            flagImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Constants.Layout.spacing),
            flagImageView.heightAnchor.constraint(equalToConstant: Constants.Detail.flagHeight),

            nameLabel.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: Constants.Layout.spacing),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Constants.Layout.spacing),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Constants.Layout.spacing),

            infoStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.Layout.spacing),
            infoStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0),
            infoStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 0),
            infoStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Constants.Layout.spacing)
        ])
    }
    
    func configure(with model: CountryDetailsModel) {
        nameLabel.text = model.name
        flagImageView.loadImage(from: model.flagURL)

        infoStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        addRow(title: Constants.Strings.detailCapital, value: model.capital)
        addRow(title: Constants.Strings.detailRegion, value: model.region)
        addRow(title: Constants.Strings.detailSubregion, value: model.subregion)
        addRow(title: Constants.Strings.detailPopulation, value: model.population.formatted())
        addRow(title: Constants.Strings.detailArea, value: model.area)
        addRow(title: Constants.Strings.detailCurrencies, value: model.currency)
        addRow(title: Constants.Strings.detailLanguages, value: model.languages, showsDivider: false)
    }

    private func addRow(title: String, value: String, showsDivider: Bool = true) {
        let rowConfiguration = LabelRowViewConfiguration(title: title.localized, value: value, showsDivider: showsDivider)
        let rowView = LabelRowView(configuration: rowConfiguration)
        infoStack.addArrangedSubview(rowView)
    }

    func setLoading(_ isLoading: Bool) {
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

