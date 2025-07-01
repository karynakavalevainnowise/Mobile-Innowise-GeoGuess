import Foundation

enum Endpoint {
    case allCountries
    case countryDetails(code: String)
    case allCountryDetailsForQuiz

    var path: String {
        switch self {
        case .allCountries:
            return "/v3.1/all"
        case .countryDetails(let code):
            return "/v3.1/alpha/\(code)"
        case .allCountryDetailsForQuiz:
            return "/v3.1/all"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .allCountries:
            return [URLQueryItem(name: "fields", value: "name,flags,continents,cca3")]
        case .allCountryDetailsForQuiz:
            return [URLQueryItem(name: "fields", value: "name,capital,region,population,currencies,idd,flags,cca3")]
        default:
            return nil
        }
    }
} 
