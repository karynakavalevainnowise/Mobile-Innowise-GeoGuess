import UIKit

enum Constants {
    
    enum Layout {
        static let cornerRadius: CGFloat = 8
        static let buttonHeight: CGFloat = 48
        static let fieldHeight: CGFloat = 48
        static let horizontalPadding: CGFloat = 24
        static let titleTopInset: CGFloat = 40
        static let stackTopSpacing: CGFloat = 60
        static let spacing: CGFloat = 16
        static let animWidthRatio: CGFloat = 0.6
        static let dividerHeight: CGFloat = 1.0
        static let textVerticalPadding: CGFloat = 8
        static let listContentInset: CGFloat = 12
        static let offlineBannerHeight: CGFloat = 30
    }
    
    enum Colours {
        static let primary = UIColor.systemBlue
        static let secondary = UIColor.secondarySystemBackground
        static let validationError = UIColor.systemRed
        static let loadingOverlay = UIColor.black.withAlphaComponent(0.5)
        static let tertiaryText = UIColor.gray
        static let primaryButtonText = UIColor.white
        static let cellBorder = UIColor.systemGray4.cgColor
        static let shadow = UIColor.black.cgColor
        static let offlineBannerBackground = UIColor.systemYellow
        static let offlineBannerText = UIColor.white
        
        enum Gradient {
            static let dark: [CGColor] = [
                UIColor(red: 0.0, green: 0.2, blue: 0.25, alpha: 1.0).cgColor,
                UIColor(red: 0.1, green: 0.3, blue: 0.4, alpha: 1.0).cgColor
            ]
            static let light: [CGColor] = [
                UIColor.systemBlue.withAlphaComponent(0.3).cgColor,
                UIColor.systemTeal.withAlphaComponent(0.3).cgColor
            ]
        }
    }
    
    enum Animation {
        static let duration: TimeInterval = 0.3
        static let splashName = "traveler"
        
        enum Gradient {
            static let duration: TimeInterval = 5.0
        }
        
        enum Wave {
            static let duration: TimeInterval = 0.5
            static let delay: TimeInterval = 0.1
            static let translationY: CGFloat = -10
        }
    }
    
    enum Typography {
        static let title = UIFont.systemFont(ofSize: 32, weight: .bold)
        static let button = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let link = UIFont.systemFont(ofSize: 14)
        static let offlineBanner = UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    
    enum Strings {
        // Auth Screen
        static let emailPlaceholder = "email_placeholder"
        static let passwordPlaceholder = "password_placeholder"
        static let signIn = "sign_in_button_title"
        static let continueGuest = "continue_as_guest_button_title"
        static let forgotPassword = "forgot_password_button_title"
        static let appTitle = "app_title"
        
        // Splash Screen
        static let splashDescription = "splash_description"
        
        // Home Screen
        static let homeTitle = "home_title"
        static let homeSubtitle = "home_subtitle"
        static let homeStartQuiz = "home_start_quiz"
        static let homeBrowseCountries = "home_browse_countries"
        static let homeLogout = "home_logout"
        
        // Countries List
        static let listTitle = "countries_list_title"
        static let offlineMode = "offline_mode_banner"
        static let noCountries = "no_countries_found"
        
        // Country Details
        static let detailTitle = "detail_title"
        static let detailCapital = "detail_capital"
        static let detailRegion = "detail_region"
        static let detailSubregion = "detail_subregion"
        static let detailPopulation = "detail_population"
        static let detailArea = "detail_area"
        static let detailCurrencies = "detail_currencies"
        static let detailLanguages = "detail_languages"
        static let detailOfflineErrorTitle = "detail_offline_error_title"
        static let detailOfflineErrorMessage = "detail_offline_error_message"
        
        // Tab Bar
        static let tabBarHome = "tab_bar_home"
        static let tabBarCountries = "tab_bar_countries"
        
        // General
        static let unknown = "unknown"
        static let ok = "ok_button_title"
        static let loginFailed = "login_failed_alert_title"
        static let invalidCredentials = "invalid_credentials_error"
        static let errorTitle = "error_title"
        static let oopsTitle = "oops_title"
        
        // Quiz
        static let quizFinished = "quiz_finished"
        static let close = "close"
        static let playAgain = "play_again"
        static let score = "score"
    }
    
    enum Icons {
        static let envelope = "envelope"
        static let lock = "lock"
        static let eye = "eye"
        static let eyeSlash = "eye.slash"
        static let photo = "photo"
        static let home = "house"
        static let countries = "list.bullet"
        static let globe = "globe.europe.africa"
    }

    enum Cell {
        static let flagWidth: CGFloat = 64
        static let flagHeight: CGFloat = 40
        static let textStackSpacing: CGFloat = 4
        
        enum Shadow {
            static let opacity: Float = 0.2
            static let radius: CGFloat = 3
            static let offset = CGSize(width: 0, height: 2)
        }
        
        enum Border {
            static let width: CGFloat = 0.5
        }
    }

    enum Detail {
        static let cardCornerRadius: CGFloat = 20
        static let flagHeight: CGFloat = 180
        static let infoStackSpacing: CGFloat = 1
        
        enum Shadow {
            static let opacity: Float = 0.1
            static let radius: CGFloat = 10
            static let offset = CGSize(width: 0, height: 4)
        }
    }
}
