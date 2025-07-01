protocol HomeCoordinating: AnyObject {
    func startQuiz()
    func openCatalog()
    func didRequestLogout()
}

final class HomeViewModel {
    weak var coordinator: HomeCoordinating?
    private let authorizationService: AuthorizationServiceProtocol
    
    var isGuest: Bool {
        authorizationService.isGuest
    }
    
    init(
        coordinator: HomeCoordinating?,
        authorizationService: AuthorizationServiceProtocol
    ) {
        self.coordinator = coordinator
        self.authorizationService = authorizationService
    }

    func handleStartQuizTapped() {
        coordinator?.startQuiz()
    }

    func handleBrowseCountriesTapped() {
        coordinator?.openCatalog()
    }

    func handleLogoutTapped() {
        coordinator?.didRequestLogout()
    }
}
