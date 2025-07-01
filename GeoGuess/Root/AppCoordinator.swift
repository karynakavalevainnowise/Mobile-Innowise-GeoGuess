import UIKit

final class AppCoordinator: ParentCoordinator {
    var navigationController: UINavigationController
    var childCoordinators: [ChildCoordinator] = []
    private let authorizationService: AuthorizationServiceProtocol
    
    init(
        navigationController: UINavigationController,
        authorizationService: AuthorizationServiceProtocol
    ) {
        self.navigationController = navigationController
        self.authorizationService = authorizationService
    }
    
    func start() {
        runSplashFlow()
    }

    private func runSplashFlow() {
        let splashVC = SplashViewController()
        splashVC.onFinish = { [weak self] in
            self?.runDecisionFlow()
        }
        navigationController.setRootViewController(splashVC, animated: false)
        navigationController.navigationBar.isHidden = true
    }

    private func runDecisionFlow() {
        if authorizationService.isLoggedIn {
            runMainFlow()
        } else {
            runAuthFlow()
        }
    }

    private func runMainFlow() {
        let mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            authorizationService: authorizationService
        )
        mainCoordinator.onFinish = { [weak self, weak mainCoordinator] in
            self?.authorizationService.logout()
            if let mainCoordinator = mainCoordinator {
                self?.removeChild(mainCoordinator)
            }
            self?.runAuthFlow()
        }
        mainCoordinator.start()
        addChild(mainCoordinator)
    }

    private func runAuthFlow() {
        let authCoordinator = AuthorizationCoordinator(
            navigationController: navigationController,
            authorizationService: authorizationService
        )
        authCoordinator.onFinish = { [weak self, weak authCoordinator] in
            if let authCoordinator = authCoordinator {
                self?.removeChild(authCoordinator)
            }
            self?.runMainFlow()
        }
        authCoordinator.start()
        addChild(authCoordinator)
    }
}
