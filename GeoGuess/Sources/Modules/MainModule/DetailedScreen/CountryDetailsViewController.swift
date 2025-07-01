import Combine
import UIKit

final class CountryDetailsViewController: BaseViewController<CountryDetailsView> {
    private let viewModel: CountryDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: CountryDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = Constants.Strings.detailTitle.localized
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.$countryDetail
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.rootView.configure(with: model)
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.rootView.setLoading(isLoading)
            }
            .store(in: &cancellables)
    }
}
