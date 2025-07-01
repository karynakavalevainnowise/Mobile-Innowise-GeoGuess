import UIKit

@MainActor
final class AlertCoordinator {
    static func present(
        from presenter: UIViewController,
        title: String,
        message: String,
        buttonTitle: String = Constants.Strings.ok.localized
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
        presenter.present(alert, animated: true)
    }
} 
