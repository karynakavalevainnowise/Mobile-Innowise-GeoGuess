struct CountryDTO: Decodable {
    let name: Name
    let flags: Flags
    let continents: [String]
    let cca3: String

    struct Name: Decodable {
        let common: String
    }

    struct Flags: Decodable {
        let png: String
    }
}
