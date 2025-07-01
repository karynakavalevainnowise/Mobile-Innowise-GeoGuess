import Combine
import Foundation

@MainActor
protocol CountriesListCoordinating: AnyObject {
    func presentCountryDetails(for country: CountryModel)
    func showCountriesLoadingError(_ error: Error)
    func showOfflineAlert()
}

final class CountriesListViewModel {
    @Published var isLoading: Bool = false
    @Published var countries: [CountryModel] = []
    @Published private(set) var isOffline = false
    
    weak var coordinator: CountriesListCoordinating?
    private var cancellables = Set<AnyCancellable>()
    
    private var networkManager: NetworkManaging
    private var swiftDataService: SwiftDataService
    private let networkMonitor: NetworkMonitor
    
    init(coordinator: CountriesListCoordinating?,
         networkManager: NetworkManaging,
         swiftDataService: SwiftDataService,
         networkMonitor: NetworkMonitor) {
        self.coordinator = coordinator
        self.networkManager = networkManager
        self.swiftDataService = swiftDataService
        self.networkMonitor = networkMonitor
        
        subscribeToNetworkChanges()
        loadCountries()
    }
    
    private func subscribeToNetworkChanges() {
        networkMonitor.isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                guard let self = self else { return }
                self.isOffline = !isConnected
                if isConnected && self.countries.isEmpty {
                    self.loadCountries()
                }
            }
            .store(in: &cancellables)
    }
    
    func loadCountries() {
        guard !isLoading else { return }
        isLoading = true
        Task { [weak self] in
            guard let self else { return }
            defer {
                Task { @MainActor in self.isLoading = false }
            }
            
            do {
                if !NetworkMonitor.shared.isConnected.value {
                    await MainActor.run { self.coordinator?.showOfflineAlert() }
                }
                let response = try await networkManager.fetchCountries()
                let fetchedCountries = response.map { CountryModel(from: $0) }                
                await MainActor.run {
                    self.swiftDataService.save(countries: fetchedCountries)
                    self.countries = fetchedCountries
                }
            } catch {
                await loadFromCache(error: error)
            }
        }
    }

    func handleSelection(at index: Int) {
        guard countries.indices.contains(index) else { return }
        let selectedCountry = countries[index]
        Task { @MainActor in coordinator?.presentCountryDetails(for: selectedCountry) }
    }
    
    private func loadFromCache(error: Error) async {
        let cachedCountries = self.swiftDataService.fetchCountries()
        if !cachedCountries.isEmpty {
            await MainActor.run {
                self.countries = cachedCountries
            }
        } else {
            await MainActor.run {
                self.coordinator?.showCountriesLoadingError(error)
            }
        }
    }
}

private extension CountryModel {
    convenience init(from response: CountryDTO) {
        self.init(
            name: response.name.common,
            continent: response.continents.first ?? "-",
            flagURL: URL(string: response.flags.png),
            code: response.cca3
        )
    }
}

