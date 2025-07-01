import UIKit

final class QuizViewController: BaseViewController<QuizView> {

    private let viewModel: QuizViewModel
    var onFinish: (() -> Void)?

    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.start()
    }

    private func bind(to viewModel: QuizViewModel) {
        viewModel.onQuestion = { [weak self] question, progress in
            guard let question = question else { return }
            self?.rootView.render(question: question,
                                  progress: progress,
                                  currentIndex: viewModel.currentQuestionIndex,
                                  totalCount: viewModel.totalQuestions) { [weak viewModel] chosen in
                viewModel?.choose(chosen)
            }
        }

        viewModel.onFeedback = { [weak self] isCorrect, chosen, correct in
            guard let correct = correct else { return }
            self?.rootView.showFeedback(isCorrect: isCorrect,
                                        chosen: chosen,
                                        correctAnswer: correct)
        }

        viewModel.onFinished = { [weak self] score, total in
            self?.presentResultAlert(score: score, total: total)
        }
    }

    private func presentErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: Constants.Strings.errorTitle.localized,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.ok.localized, style: .default))
        present(alert, animated: true)
    }

    private func presentResultAlert(score: Int, total: Int) {
        let alert = UIAlertController(title: Constants.Strings.quizFinished.localized,
                                      message: String.localizedStringWithFormat(Constants.Strings.score.localized, score, total)
                                      ,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.playAgain.localized, style: .default) { _ in
            self.viewModel.start()
        })
        alert.addAction(UIAlertAction(title: Constants.Strings.close.localized, style: .cancel) { [weak self] _ in
            self?.onFinish?()
        })
        present(alert, animated: true)
    }
}
