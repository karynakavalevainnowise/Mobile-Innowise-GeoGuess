import Foundation

struct CountryDetailsModel: Hashable {
    let name: String
    let capital: String
    let region: String
    let subregion: String
    let population: Int
    let area: String
    let currency: String
    let phoneCode: String
    let languages: String
    let timezones: [String]
    let borders: [String]
    let flagURL: URL
}

extension CountryDetailsModel {
    init(dto: CountryDetailsDTO) {
        let unknown = Constants.Strings.unknown

        name       = dto.name.common
        capital    = dto.capital?.first ?? unknown
        region     = dto.region
        subregion  = dto.subregion ?? unknown
        population = dto.population

        if let areaValue = dto.area {
            area = String(format: "%.0f km²", areaValue)
        } else {
            area = unknown
        }

        currency = dto.currencies?.first?.value.name ?? unknown

        let suffix = dto.idd.suffixes?.first ?? unknown
        phoneCode = "\(dto.idd.root)\(suffix)"

        if let langs = dto.languages {
            languages = langs.values.sorted().joined(separator: ", ")
        } else {
            languages = unknown
        }

        timezones = dto.timezones ?? []
        borders   = dto.borders ?? []

        flagURL = dto.flags.png
    }
}
