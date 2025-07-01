import Combine
import Foundation

final class AuthorizationViewModel {
    struct Output {
        let emailValid: AnyPublisher<Bool, Never>
        let passwordValid: AnyPublisher<Bool, Never>
        let isLoginButtonEnabled: AnyPublisher<Bool, Never>
        let isLoading: AnyPublisher<Bool, Never>
    }

    @Published private var email = ""
    @Published private var password = ""
    @Published private var isLoading = false

    private let authService: AuthorizationServiceProtocol
    private weak var coordinator: AuthorizationCoordinatorProtocol?

    init(authService: AuthorizationServiceProtocol, coordinator: AuthorizationCoordinatorProtocol?) {
        self.authService = authService
        self.coordinator = coordinator
    }

    func transform() -> Output {
        let emailValid = $email
            .map { email in
                email.isEmpty || Validator.isValidEmail(email)
            }
            .removeDuplicates()
            .eraseToAnyPublisher()

        let passwordValid = $password
            .map { password in
                password.isEmpty || Validator.isValidPassword(password)
            }
            .removeDuplicates()
            .eraseToAnyPublisher()

        let isLoginButtonEnabled = Publishers.CombineLatest3($email, $password, $isLoading)
            .map { email, password, loading in
                !loading &&
                !email.isEmpty &&
                !password.isEmpty &&
                Validator.isValidEmail(email) &&
                Validator.isValidPassword(password)
            }
            .removeDuplicates()
            .eraseToAnyPublisher()

        return Output(
            emailValid: emailValid,
            passwordValid: passwordValid,
            isLoginButtonEnabled: isLoginButtonEnabled,
            isLoading: $isLoading.eraseToAnyPublisher()
        )
    }

    func updateEmail(_ value: String) { email = value }
    func updatePassword(_ value: String) { password = value }

    func login() {
        guard !isLoading else { return }
        
        Task {
            await MainActor.run { isLoading = true }
            defer {
                Task { @MainActor in isLoading = false }
            }
            
            let success = await authService.login(email: email, password: password)
            
            await MainActor.run {
                if success {
                    coordinator?.didAuthenticateSuccessfully()
                } else {
                    coordinator?.showErrorAlert(message: Constants.Strings.invalidCredentials.localized)
                }
            }
        }
    }
    
    func loginAsGuest() {
        authService.loginAsGuest()
        coordinator?.didAuthenticateSuccessfully()
    }
}
