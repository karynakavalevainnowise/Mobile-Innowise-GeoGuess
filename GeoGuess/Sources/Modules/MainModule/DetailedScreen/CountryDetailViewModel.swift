import Combine
import Foundation

protocol CountryDetailCoordinating: AnyObject {
    func showCountryDetailLoadingError(_ error: Error)
}

class CountryDetailViewModel {
    @Published var countryDetail: CountryDetailsModel?
    @Published var isLoading = false
    @Published private(set) var error: Error?
    
    private let countryID: String
    private let service: NetworkManaging
    private weak var coordinator: CountryDetailCoordinating?
    private var cancellables = Set<AnyCancellable>()
    
    init(countryID: String, service: NetworkManaging, coordinator: CountryDetailCoordinating?) {
        self.countryID = countryID
        self.service = service
        self.coordinator = coordinator
        loadDetail()
    }
    
    func loadDetail() {
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                let detail = try await service.fetchCountryDetails(code: countryID)
                await MainActor.run {
                    self.countryDetail = CountryDetailsModel(dto: detail)
                }
            } catch {
                await MainActor.run {
                    self.coordinator?.showCountryDetailLoadingError(error)
                }
            }
        }
    }
}
