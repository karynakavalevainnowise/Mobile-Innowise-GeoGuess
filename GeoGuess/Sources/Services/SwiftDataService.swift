import SwiftData
import Foundation

final class SwiftDataService {
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    init() throws {
        let container = try ModelContainer(for: CountryModel.self)
        self.modelContainer = container
        self.modelContext = ModelContext(modelContainer)
    }
    
    func fetchCountries() -> [CountryModel] {
        let descriptor = FetchDescriptor<CountryModel>(sortBy: [SortDescriptor(\CountryModel.name)])
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            debugPrint("Failed to fetch countries from SwiftData: \(error)")
            return []
        }
    }

    func save(countries: [CountryModel]) {
        do {
            try modelContext.delete(model: CountryModel.self)
            countries.forEach { modelContext.insert($0) }
            try modelContext.save()
        } catch {
            debugPrint("Failed to save countries to SwiftData: \(error)")
        }
    }
    
    func insert(_ country: CountryModel) {
        modelContext.insert(country)
        do {
            try modelContext.save()
        } catch {
            debugPrint("Failed to insert country: \(error)")
        }
    }
    
    func delete(_ country: CountryModel) {
        let countryId = country.id
        let predicate = #Predicate<CountryModel> { $0.id == countryId }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            if let countryToDelete = try modelContext.fetch(descriptor).first {
                modelContext.delete(countryToDelete)
                try modelContext.save()
            }
        } catch {
            debugPrint("Failed to delete country: \(error)")
        }
    }
} 
