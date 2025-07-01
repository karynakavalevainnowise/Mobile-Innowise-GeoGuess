import UIKit

extension UINavigationController {
    func setRootViewController(_ viewController: UIViewController, animated: Bool = false) {
        setViewControllers([viewController], animated: animated)
    }
}
