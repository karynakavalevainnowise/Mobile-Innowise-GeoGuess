import Combine
import Foundation

final class AuthorizationViewController: BaseViewController<AuthorizationView> {
    
    private let viewModel: AuthorizationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: AuthorizationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wireUserEvents()
        bind(viewModel.transform())
    }
    
    private func wireUserEvents() {
        rootView.onEmailChanged = { [weak self] in self?.viewModel.updateEmail($0) }
        rootView.onPasswordChanged = { [weak self] in self?.viewModel.updatePassword($0) }
        rootView.onSignIn = { [weak self] in self?.viewModel.login() }
        rootView.onGuest = { [weak self] in self?.viewModel.loginAsGuest() }
    }
    
    private func bind(_ output: AuthorizationViewModel.Output) {
        output.isLoginButtonEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.rootView.setSignInEnabled($0) }
            .store(in: &cancellables)
        
        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.rootView.setLoading($0) }
            .store(in: &cancellables)
        
        output.emailValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.rootView.setEmailValid($0) }
            .store(in: &cancellables)
        
        output.passwordValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.rootView.setPasswordValid($0) }
            .store(in: &cancellables)
    }
}
