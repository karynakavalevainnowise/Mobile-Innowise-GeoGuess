import Foundation

protocol AuthorizationServiceProtocol {
    var isLoggedIn: Bool { get }
    var isGuest: Bool { get }
    func login(email: String, password: String) async -> Bool
    func loginAsGuest()
    func logout()
}

final class AuthorizationService: AuthorizationServiceProtocol {
    private let userDefaults: UserDefaults
    private let loggedInKey = "isLoggedIn"
    private let isGuestKey = "isGuest"
    
    private let users = [
        "test@example.com": "12345",
        "admin@example.com": "adminpass"
    ]
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    var isLoggedIn: Bool {
        userDefaults.bool(forKey: loggedInKey)
    }
    
    var isGuest: Bool {
        userDefaults.bool(forKey: isGuestKey)
    }
    
    func login(email: String, password: String) async -> Bool {
        // Simulate a network delay
        try? await Task.sleep(for: .seconds(0.5))
        
        let success = users[email] == password
        if success {
            userDefaults.set(true, forKey: loggedInKey)
            userDefaults.set(false, forKey: isGuestKey)
        }
        return success
    }
    
    func loginAsGuest() {
        userDefaults.set(true, forKey: loggedInKey)
        userDefaults.set(true, forKey: isGuestKey)
    }
    
    func logout() {
        userDefaults.set(false, forKey: loggedInKey)
        userDefaults.set(false, forKey: isGuestKey)
    }
}
