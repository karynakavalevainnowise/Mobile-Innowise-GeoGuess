import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        NetworkMonitor.shared.start()
        
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let authService = AuthorizationService()
        let appCoordinator = AppCoordinator(
            navigationController: navigationController,
            authorizationService: authService
        )
        
        self.window = window
        self.appCoordinator = appCoordinator
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        appCoordinator.start()
    }
}
