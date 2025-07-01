import Foundation

final class QuizViewModel {
    var onQuestion:  ((Question?, Float) -> Void)?
    var onFeedback: ((Bool, String, String?) -> Void)?
    var onFinished:  ((Int, Int) -> Void)?

    private let generator: QuestionGenerator
    private var session:  QuizSession
    
    var currentQuestionIndex: Int {
        return session.index
    }

    var totalQuestions: Int {
        return session.questions.count
    }

    init(countries: [CountryDetailsModel]) {
        self.generator = QuestionGenerator(countries: countries)
        self.session   = QuizSession(questions: [])  
    }

    func start() {
        let freshTen = generator.makeTenUniqueQuestions()
        session = QuizSession(questions: freshTen)
        emitCurrent()
    }

    func choose(_ option: String) {
        let isCorrect     = session.submit(answer: option)
        let correctAnswer = session.current?.correctAnswer

        onFeedback?(isCorrect, option, correctAnswer)

        if session.isFinished {
            onFinished?(session.correctCount, session.questions.count)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.emitCurrent()
            }
        }
    }

    private func emitCurrent() {
        onQuestion?(session.current, session.progress)
    }
}
