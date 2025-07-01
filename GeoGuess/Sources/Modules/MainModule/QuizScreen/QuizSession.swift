struct QuizSession {
    private(set) var questions: [Question]
    private(set) var index: Int = 0
    private(set) var correctCount: Int = 0

    var current: Question? {
        guard index < questions.count else { return nil }
        return questions[index]
    }

    var progress: Float {
        Float(index) / Float(questions.count)
    }

    mutating func submit(answer: String) -> Bool {
        guard let question = current else { return false }
        let isCorrect = answer == question.correctAnswer
        if isCorrect { correctCount += 1 }
        index += 1
        return isCorrect
    }

    var isFinished: Bool {
        index >= questions.count
    }
}
