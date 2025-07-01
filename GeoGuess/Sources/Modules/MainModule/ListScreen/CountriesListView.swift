import UIKit

final class CountriesListView: UIView {
    let tableView: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.backgroundColor = .clear
        let inset = Constants.Layout.listContentInset
        table.contentInset = .init(top: inset, left: 0, bottom: inset, right: 0)
        return table
    }()
    
    private let loadingView = LoadingIndicatorView()
    
    private let offlineBanner: UILabel = {
        let label = UILabel()
        label.text = Constants.Strings.offlineMode.localized
        label.textAlignment = .center
        label.backgroundColor = Constants.Colours.offlineBannerBackground
        label.textColor = Constants.Colours.offlineBannerText
        label.font = Constants.Typography.offlineBanner
        label.alpha = 0
        label.isHidden = true
        return label
    }()
    
    private let emptyStateView: EmptyStateView = {
        let image = UIImage(systemName: Constants.Icons.globe)
        let message = NSLocalizedString(Constants.Strings.noCountries.localized, comment: "")
        let view = EmptyStateView(image: image, message: message)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .systemBackground
        addSubviews(tableView, offlineBanner, loadingView, emptyStateView)
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.reuseID)
        tableView.pinToEdges(of: self)
        loadingView.pinToEdges(of: self)
        
        offlineBanner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            offlineBanner.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            offlineBanner.leadingAnchor.constraint(equalTo: leadingAnchor),
            offlineBanner.trailingAnchor.constraint(equalTo: trailingAnchor),
            offlineBanner.heightAnchor.constraint(equalToConstant: Constants.Layout.offlineBannerHeight),
            emptyStateView.topAnchor.constraint(equalTo: topAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setLoadingState(_ isLoading: Bool) {
        if isLoading {
            loadingView.startAnimating()
        } else {
            loadingView.stopAnimating()
        }
        
        UIView.animate(withDuration: Constants.Animation.duration) {
            self.loadingView.alpha = isLoading ? 1.0 : 0.0
        }
    }
    
    func showOfflineBanner(_ isVisible: Bool) {
        let bannerHeight = Constants.Layout.offlineBannerHeight
        let topInset = isVisible ? Constants.Layout.listContentInset + bannerHeight : Constants.Layout.listContentInset
        
        if isVisible {
            offlineBanner.isHidden = false
        }
        
        UIView.animate(withDuration: Constants.Animation.duration, animations: {
            self.offlineBanner.alpha = isVisible ? 1.0 : 0.0
            self.tableView.contentInset.top = topInset
        }, completion: { _ in
            if !isVisible {
                self.offlineBanner.isHidden = true
            }
        })
    }
    
    func showEmptyState(_ isEmpty: Bool) {
        emptyStateView.isHidden = !isEmpty
    }
}
