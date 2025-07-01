import UIKit

protocol AuthorizationCoordinatorProtocol: AnyObject {
    func showErrorAlert(message: String)
    func didAuthenticateSuccessfully()
}

final class AuthorizationCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    private let authorizationService: AuthorizationServiceProtocol

    var onFinish: (() -> Void)?

    init(
        navigationController: UINavigationController,
        authorizationService: AuthorizationServiceProtocol
    ) {
        self.navigationController = navigationController
        self.authorizationService = authorizationService
    }

    func start() {
        let viewModel = AuthorizationViewModel(authService: authorizationService, coordinator: self)
        let authorizationVC = AuthorizationViewController(viewModel: viewModel)

        navigationController.setRootViewController(authorizationVC, animated: true)
    }
}

extension AuthorizationCoordinator: AuthorizationCoordinatorProtocol {
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: Constants.Strings.loginFailed.localized,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Constants.Strings.ok.localized, style: .default))
        navigationController.present(alert, animated: true)
    }
    
    func didAuthenticateSuccessfully() {
        onFinish?()
    }
}
