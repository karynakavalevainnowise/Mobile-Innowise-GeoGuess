import UIKit

// MARK: - Generic base VC that injects a custom root view.
class BaseViewController<ContentView: UIView>: UIViewController {

    /// Strong-typed root view
    var rootView: ContentView { view as! ContentView }

    override func loadView() {
        self.view = ContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGradientBackground()
    }
}
