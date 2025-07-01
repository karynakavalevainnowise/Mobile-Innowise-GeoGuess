import UIKit

final class MainCoordinator: ChildCoordinator {
    private var tabBarController: UITabBarController!
    var navigationController: UINavigationController
    var onFinish: (() -> Void)?
    
    private var homeNavigationController: UINavigationController!
    private var listNavigationController: UINavigationController!
    
    private let countriesAPI: NetworkManaging = CountriesAPI()
    private let swiftDataService: SwiftDataService
    private let authorizationService: AuthorizationServiceProtocol
    
    init(
        navigationController: UINavigationController,
        authorizationService: AuthorizationServiceProtocol
    ) {
        self.navigationController = navigationController
        self.authorizationService = authorizationService
        self.tabBarController = UITabBarController()
        do {
            self.swiftDataService = try SwiftDataService()
        } catch {
            fatalError("Failed to initialize SwiftDataService: \(error)")
        }
    }
    
    func start() {
        setupAppearance()
        setupTabs()
    }
    
    private func setupAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        tabBarController.tabBar.standardAppearance = tabBarAppearance
        tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance
    }
    
    private func setupTabs() {
        let homeViewModel = HomeViewModel(
            coordinator: self,
            authorizationService: authorizationService
        )
        let homeVC = HomeViewController(viewModel: homeViewModel)
        
        let viewModel = CountriesListViewModel(
            coordinator: self,
            networkManager: countriesAPI,
            swiftDataService: swiftDataService,
            networkMonitor: .shared
        )
        let listVC = CountriesListViewController(viewModel: viewModel)
        
        homeVC.tabBarItem = UITabBarItem(title: Constants.Strings.tabBarHome.localized, image: UIImage(systemName: Constants.Icons.home), tag: 0)
        listVC.tabBarItem = UITabBarItem(title: Constants.Strings.tabBarCountries.localized, image: UIImage(systemName: Constants.Icons.countries), tag: 1)
        
        homeNavigationController = UINavigationController(rootViewController: homeVC)
        listNavigationController = UINavigationController(rootViewController: listVC)
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        navBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        listNavigationController.navigationBar.standardAppearance = navBarAppearance
        listNavigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        tabBarController.viewControllers = [homeNavigationController, listNavigationController]
        navigationController.setViewControllers([tabBarController], animated: true)
    }
}

extension MainCoordinator: CountriesListCoordinating, CountryDetailCoordinating {
    func presentCountryDetails(for country: CountryModel) {
        let vm = CountryDetailViewModel(countryID: country.code, service: countriesAPI, coordinator: self)
        let vc = CountryDetailsViewController(viewModel: vm)
        
        vc.modalPresentationStyle = .formSheet
        listNavigationController.present(vc, animated: true)
    }
    
    func showOfflineAlert() {
        AlertCoordinator.present(
            from: tabBarController,
            title: Constants.Strings.detailOfflineErrorTitle.localized,
            message: Constants.Strings.detailOfflineErrorMessage.localized
        )
    }
    
    func showCountriesLoadingError(_ error: Error) {
        AlertCoordinator.present(
            from: tabBarController,
            title: Constants.Strings.errorTitle.localized,
            message: error.localizedDescription
        )
    }
    
    func showCountryDetailLoadingError(_ error: Error) {
        // If the detail view is already presented, dismiss it first, then show the alert.
        if let detailVC = tabBarController.presentedViewController as? CountryDetailsViewController {
            Task { @MainActor in
                detailVC.dismiss(animated: true) {
                    AlertCoordinator.present(
                        from: self.tabBarController,
                        title: Constants.Strings.oopsTitle.localized,
                        message: error.localizedDescription
                    )
                }
            }
        } else {
            // Otherwise, just show the alert from the tab bar controller.
            Task { @MainActor in
                AlertCoordinator.present(
                    from: tabBarController,
                    title: Constants.Strings.oopsTitle.localized,
                    message: error.localizedDescription
                )
            }
        }
    }
}

extension MainCoordinator: HomeCoordinating {
    func startQuiz() {
        Task {
            do {
                let dtos = try await countriesAPI.fetchAllCountryDetailsForQuiz()
                let models = dtos.map(CountryDetailsModel.init(dto:))
                
                await MainActor.run {
                    let viewModel = QuizViewModel(countries: models)
                    let quizVC = QuizViewController(viewModel: viewModel)
                    quizVC.modalPresentationStyle = .fullScreen
                    
                    quizVC.onFinish = { [weak self] in
                        self?.homeNavigationController.dismiss(animated: true)
                    }
                    
                    self.homeNavigationController.present(quizVC, animated: true)
                }
            } catch {
                await MainActor.run {
                    self.presentErrorAlert(error)
                }
            }
        }
    }
    
    func openCatalog() {
        tabBarController.selectedIndex = 1
    }
    
    func didRequestLogout() {
        onFinish?()
    }
    
    private func presentErrorAlert(_ error: Error) {
        Task { @MainActor in
            AlertCoordinator.present(
                from: tabBarController,
                title: Constants.Strings.errorTitle.localized,
                message: error.localizedDescription
            )
        }
    }
}
