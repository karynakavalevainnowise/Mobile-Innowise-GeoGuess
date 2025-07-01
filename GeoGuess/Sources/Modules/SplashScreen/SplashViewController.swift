import Foundation

final class SplashViewController: BaseViewController<SplashView>, Finishable {
    var onFinish: (() -> Void)?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.onFinish?()
        }
    }
}
