import Foundation
import UIKit

final class HomeViewController: BaseViewController<HomeView> {
    private let viewModel: HomeViewModel

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        rootView.onStartQuiz = { [weak self] in self?.viewModel.handleStartQuizTapped() }
        rootView.onBrowseCountries = { [weak self] in self?.viewModel.handleBrowseCountriesTapped() }
    }
    
    private func setupNavigationBar() {
        let titleKey = viewModel.isGuest ? Constants.Strings.signIn : Constants.Strings.homeLogout
        let logoutButton = UIBarButtonItem(
            title: titleKey.localized,
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )
        navigationItem.rightBarButtonItem = logoutButton
    }

    @objc private func didTapLogout() {
        viewModel.handleLogoutTapped()
    }
}
