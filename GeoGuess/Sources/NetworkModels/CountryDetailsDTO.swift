import Foundation

struct CountryDetailsDTO: Decodable {
    struct Name: Decodable { let common: String }
    struct Flag: Decodable { let png: URL }
    struct CurrencyDetail: Decodable { let name: String }
    struct IDD: Decodable { let root: String; let suffixes: [String]? }
    struct LanguageDetail: Decodable { let name: String }

    let name: Name
    let capital: [String]?
    let region: String
    let subregion: String?
    let population: Int
    let area: Double?
    let languages: [String: String]?
    let currencies: [String: CurrencyDetail]?
    let idd: IDD
    let flags: Flag
    let timezones: [String]?
    let borders: [String]?
}
