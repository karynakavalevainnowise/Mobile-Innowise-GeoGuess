import SwiftData
import Foundation

@Model
final class CountryModel: Identifiable {
    @Attribute(.unique) var code: String
    var name: String
    var continent: String
    var flagURL: URL?
    
    init(name: String, continent: String, flagURL: URL?, code: String) {
        self.name = name
        self.continent = continent
        self.flagURL = flagURL
        self.code = code
    }
}
