import Combine
import UIKit

final class CountriesListViewController: BaseViewController<CountriesListView> {
    private let viewModel: CountriesListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private enum Section {
        case main
    }
    private var dataSource: UITableViewDiffableDataSource<Section, CountryModel>!
    private var snapshot = NSDiffableDataSourceSnapshot<Section, CountryModel>()
    
    init(viewModel: CountriesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Strings.listTitle.localized
        setupNavigationBar()
        bindViewModel()
        setupDelegates()
        configureDataSource()
    }
    
    private func setupNavigationBar() {
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(didTapRefresh)
        )
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    private func bindViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.rootView.setLoadingState(isLoading)
                self?.navigationItem.rightBarButtonItem?.isEnabled = !isLoading
            }
            .store(in: &cancellables)
        
        viewModel.$countries
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.applySnapshot(with: model)
            }
            .store(in: &cancellables)
        
        viewModel.$isOffline
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isOffline in
                self?.rootView.showOfflineBanner(isOffline)
            }
            .store(in: &cancellables)
        
        viewModel.loadCountries()
    }
    
    private func setupDelegates() {
        rootView.tableView.delegate = self
    }

    private func configureDataSource() {
        snapshot.appendSections([.main])
        dataSource = UITableViewDiffableDataSource<Section, CountryModel>(
            tableView: rootView.tableView
        ) { tableView, indexPath, country in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CountryCell.reuseID,
                for: indexPath
            ) as? CountryCell else { return UITableViewCell() }
            cell.configure(with: country)
            return cell
        }
    }
    
    private func applySnapshot(with countries: [CountryModel]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(countries)
        dataSource.apply(snapshot, animatingDifferences: false)
        rootView.showEmptyState(countries.isEmpty)
    }
    
    @objc private func didTapRefresh() {
        viewModel.loadCountries()
    }
}

extension CountriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.handleSelection(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
