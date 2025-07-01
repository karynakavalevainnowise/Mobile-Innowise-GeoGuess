import Foundation

protocol NetworkManaging {
    func fetchCountries() async throws -> [CountryDTO]
    func fetchCountryDetails(code: String) async throws -> CountryDetailsDTO
    func fetchAllCountryDetailsForQuiz() async throws -> [CountryDetailsDTO]
}

final class CountriesAPI: NetworkManaging {
    private let networkManager = NetworkManager()

    func fetchCountries() async throws -> [CountryDTO] {
        return try await networkManager.perform(endpoint: .allCountries)
    }

    func fetchCountryDetails(code: String) async throws -> CountryDetailsDTO {
        let details: [CountryDetailsDTO] = try await networkManager.perform(endpoint: .countryDetails(code: code))
        
        guard let detail = details.first else {
            throw NetworkError.noData
        }
        return detail
    }
    
    func fetchAllCountryDetailsForQuiz() async throws -> [CountryDetailsDTO] {
        return try await networkManager.perform(endpoint: .allCountryDetailsForQuiz)
    }
}
