import Foundation

enum QuestionType: CaseIterable {
    case flagToCountry        // "Which country has this flag?" (show flag image, pick country)
    case countryToFlag        // "Which flag belongs to [country]?" (show country name, pick flag)
    case capitalToCountry     // "Which country has capital [capital]?"
    case countryToCapital     // "What is the capital of [country]?"
    case regionToCountry      // "Which country is in the [region] region?"
    case countryToRegion      // "Which region does [country] belong to?"
    case closestPopulation    // "Which country has population closest to [number]?"
    case mostPopulation       // "Which country has the largest population?"
    case countryToCurrency    // "Which currency does [country] use?"
    case countryToPhoneCode   // "What is the phone code of [country]?"
}

struct Question {
    let type: QuestionType
    let questionText: String
    let correctAnswer: String   // e.g. country name or capital name etc.
    let options: [String]       // 4 options including correct answer
    let flagURL: URL?        // only for flagToCountry or countryToFlag question types
}

final class QuestionGenerator {
    private let countries: [CountryDetailsModel]
    private var usedCorrectAnswers = Set<String>()

    init(countries: [CountryDetailsModel]) {
        self.countries = countries
    }

    func makeTenUniqueQuestions() -> [Question] {
        var questions: [Question] = []
        var shuffledTypes = QuestionType.allCases.shuffled()

        // Keep generating until we have 10 questions or no types left.
        while questions.count < 10, !shuffledTypes.isEmpty {
            let type = shuffledTypes.removeFirst()
            if let question = makeQuestion(of: type) {
                questions.append(question)
                usedCorrectAnswers.insert(question.correctAnswer)
            }
        }

        // If some types failed (e.g. not enough data), randomly pick again
        // from *any* type until we have 10 or we give up after 100 attempts.
        var fallbackAttempts = 0
        while questions.count < 10, fallbackAttempts < 100 {
            fallbackAttempts += 1
            if let randomType = QuestionType.allCases.randomElement(),
               let question   = makeQuestion(of: randomType),
               !usedCorrectAnswers.contains(question.correctAnswer) {

                questions.append(question)
                usedCorrectAnswers.insert(question.correctAnswer)
            }
        }
        return questions
    }
    
    private func makeQuestion(of type: QuestionType) -> Question? {
        switch type {
        case .flagToCountry:       return makeFlagToCountry()
        case .countryToFlag:       return makeCountryToFlag()
        case .capitalToCountry:    return makeCapitalToCountry()
        case .countryToCapital:    return makeCountryToCapital()
        case .regionToCountry:     return makeRegionToCountry()
        case .countryToRegion:     return makeCountryToRegion()
        case .closestPopulation:   return makeClosestPopulation()
        case .mostPopulation:      return makeMostPopulation()
        case .countryToCurrency:   return makeCountryToCurrency()
        case .countryToPhoneCode:  return makeCountryToPhoneCode()
        }
    }

    private func makeFlagToCountry() -> Question? {
        guard let country = countries.filter({ !usedCorrectAnswers.contains($0.name) }).randomElement()
        else { return nil }

        let options = makeTextOptions(correct: country.name)
        return Question(type: .flagToCountry,
                        questionText: "Which country has this flag?",
                        correctAnswer: country.name,
                        options: options,
                        flagURL: country.flagURL)
    }

    private func makeCountryToFlag() -> Question? {
        guard let country = countries.filter({ !usedCorrectAnswers.contains($0.name) }).randomElement()
        else { return nil }

        let optionUrls = makeFlagOptions(correct: country.flagURL)
        let optionStrings = optionUrls.map(\.absoluteString)

        return Question(type: .countryToFlag,
                        questionText: "Which flag belongs to \(country.name)?",
                        correctAnswer: country.flagURL.absoluteString,
                        options: optionStrings,
                        flagURL: nil)
    }

    private func makeCapitalToCountry() -> Question? {
        guard let country = countries
                .filter({ !$0.capital.isEmpty && !usedCorrectAnswers.contains($0.name) })
                .randomElement()
        else { return nil }

        let options = makeTextOptions(correct: country.name)
        return Question(type: .capitalToCountry,
                        questionText: "Which country has the capital \(country.capital)?",
                        correctAnswer: country.name,
                        options: options,
                        flagURL: nil)
    }

    private func makeCountryToCapital() -> Question? {
        guard let country = countries
                .filter({ !$0.capital.isEmpty && !usedCorrectAnswers.contains($0.capital) })
                .randomElement()
        else { return nil }

        let allCapitals   = countries.map(\.capital).filter { !$0.isEmpty }
        let incorrectCaps = allCapitals.filter { $0 != country.capital }
        let options       = makeOptions(correct: country.capital, from: incorrectCaps)

        return Question(type: .countryToCapital,
                        questionText: "What is the capital of \(country.name)?",
                        correctAnswer: country.capital,
                        options: options,
                        flagURL: nil)
    }

    private func makeRegionToCountry() -> Question? {
        guard let country = countries
                .filter({ !$0.region.isEmpty && !usedCorrectAnswers.contains($0.name) })
                .randomElement()
        else { return nil }

        let sameRegion = countries.filter { $0.region == country.region }
        guard sameRegion.count >= 4 else { return nil }

        let correctCountry = sameRegion.randomElement()!
        let options = makeTextOptions(correct: correctCountry.name)
        return Question(type: .regionToCountry,
                        questionText: "Which country is in the \(country.region) region?",
                        correctAnswer: correctCountry.name,
                        options: options,
                        flagURL: nil)
    }

    private func makeCountryToRegion() -> Question? {
        guard let country = countries
                .filter({ !$0.region.isEmpty && !usedCorrectAnswers.contains($0.region) })
                .randomElement()
        else { return nil }

        let allRegions = Set(countries.map(\.region)).subtracting([country.region])
        let options    = makeOptions(correct: country.region, from: Array(allRegions))
        return Question(type: .countryToRegion,
                        questionText: "Which region does \(country.name) belong to?",
                        correctAnswer: country.region,
                        options: options,
                        flagURL: nil)
    }

    private func makeClosestPopulation() -> Question? {
        guard let pivotCountry = countries.filter({ !usedCorrectAnswers.contains($0.name) }).randomElement()
        else { return nil }

        let sorted = countries.sorted {
            abs($0.population - pivotCountry.population) < abs($1.population - pivotCountry.population)
        }
        let nearest = sorted.filter { $0.name != pivotCountry.name }.prefix(3).map(\.name)
        guard nearest.count == 3 else { return nil }

        var options = nearest + [pivotCountry.name]
        options.shuffle()

        let formattedPop = NumberFormatter.localizedString(from: NSNumber(value: pivotCountry.population),
                                                           number: .decimal)

        return Question(type: .closestPopulation,
                        questionText: "Which country has a population closest to \(formattedPop)?",
                        correctAnswer: pivotCountry.name,
                        options: options,
                        flagURL: nil)
    }

    private func makeMostPopulation() -> Question? {
        let topFour = countries.sorted { $0.population > $1.population }.prefix(4)
        guard topFour.count == 4 else { return nil }

        let options = topFour.map(\.name).shuffled()
        return Question(type: .mostPopulation,
                        questionText: "Which country has the largest population?",
                        correctAnswer: options.max(by: { $0 < $1 }) ?? "",
                        options: options,
                        flagURL: nil)
    }

    private func makeCountryToCurrency() -> Question? {
        guard let country = countries
                .filter({ !$0.currency.isEmpty && !usedCorrectAnswers.contains($0.currency) })
                .randomElement()
        else { return nil }

        let allCurrencies = Set(countries.map(\.currency)).subtracting([country.currency])
        let options       = makeOptions(correct: country.currency, from: Array(allCurrencies))

        return Question(type: .countryToCurrency,
                        questionText: "Which currency does \(country.name) use?",
                        correctAnswer: country.currency,
                        options: options,
                        flagURL: nil)
    }

    private func makeCountryToPhoneCode() -> Question? {
        guard let country = countries
                .filter({ !$0.phoneCode.isEmpty && !usedCorrectAnswers.contains($0.phoneCode) })
                .randomElement()
        else { return nil }

        let allCodes = countries.map(\.phoneCode).filter { $0 != country.phoneCode }
        let options  = makeOptions(correct: country.phoneCode, from: allCodes)

        return Question(type: .countryToPhoneCode,
                        questionText: "What is the phone code of \(country.name)?",
                        correctAnswer: country.phoneCode,
                        options: options,
                        flagURL: nil)
    }

    private func makeTextOptions(correct correctAnswer: String) -> [String] {
        let otherNames = countries.map(\.name).filter { $0 != correctAnswer }
        return makeOptions(correct: correctAnswer, from: otherNames)
    }

    private func makeOptions(correct correctAnswer: String, from pool: [String]) -> [String] {
        let incorrect = Array(pool.shuffled().prefix(3))
        return (incorrect + [correctAnswer]).shuffled()
    }

    private func makeFlagOptions(correct correctUrl: URL) -> [URL] {
        let otherFlags = countries.map(\.flagURL)
            .filter { $0 != correctUrl }
            .shuffled()
            .prefix(3)
        return Array(otherFlags) + [correctUrl]
    }
}
