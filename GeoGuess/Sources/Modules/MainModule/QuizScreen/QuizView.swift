import UIKit

final class QuizView: UIView {
    private let progress = UIProgressView(progressViewStyle: .default)
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Typography.title
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        return label
    }()
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Typography.title.withSize(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let flagView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var optionButtons: [UIButton] = (0..<4).map { _ in
        let button = UIButton(type: .system)
        button.layer.cornerRadius = Constants.Layout.cornerRadius
        button.titleLabel?.font = Constants.Typography.button
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = Constants.Colours.secondary
        button.clipsToBounds = true
        return button
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        buildHierarchy()
        applyConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }

    private func buildHierarchy() {
        addSubviews(progress, progressLabel, questionLabel, flagView)
        optionButtons.forEach(addSubview)
    }

    private func applyConstraints() {
        let g = layoutMarginsGuide
        [progress, progressLabel, questionLabel, flagView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        optionButtons.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: g.topAnchor, constant: Constants.Layout.spacing),
              progress.leadingAnchor.constraint(equalTo: g.leadingAnchor),
              progress.widthAnchor.constraint(equalTo: g.widthAnchor, multiplier: 0.7),

              progressLabel.leadingAnchor.constraint(equalTo: progress.trailingAnchor, constant: 8),
              progressLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor),
              progressLabel.centerYAnchor.constraint(equalTo: progress.centerYAnchor),
            questionLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: Constants.Layout.spacing),
            questionLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor),

            flagView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: Constants.Layout.spacing),
            flagView.centerXAnchor.constraint(equalTo: centerXAnchor),
            flagView.heightAnchor.constraint(equalToConstant: 120),
            flagView.widthAnchor.constraint(equalTo: flagView.heightAnchor)
        ])

        for (i, button) in optionButtons.enumerated() {
            let topAnchor = i == 0 ? flagView.bottomAnchor : optionButtons[i - 1].bottomAnchor
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Layout.spacing),
                button.leadingAnchor.constraint(equalTo: g.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: g.trailingAnchor)
            ])
        }
    }

    func render(question: Question,
                progress: Float,
                currentIndex: Int,
                totalCount: Int,
                handler: @escaping (String) -> Void) {
        progressLabel.text = "\(currentIndex)/\(totalCount)"
        self.progress.setProgress(progress, animated: true)
        questionLabel.text = question.questionText

        flagView.isHidden = question.flagURL == nil
        flagView.image = nil

        if let url = question.flagURL {
            loadImage(from: url)
        }

        for (btn, option) in zip(optionButtons, question.options) {
            btn.setTitle(option, for: .normal)
            btn.backgroundColor = Constants.Colours.secondary
            btn.isEnabled = true
            btn.removeTarget(nil, action: nil, for: .allEvents)

            btn.addAction(UIAction { _ in handler(option) }, for: .touchUpInside)
        }
    }

    func showFeedback(isCorrect: Bool,
                      chosen option: String,
                      correctAnswer: String) {
        optionButtons.forEach { button in
            guard let title = button.title(for: .normal) else { return }

            if title == option {
                button.backgroundColor = isCorrect ? .systemGreen : .systemRed
            }
            if !isCorrect && title == correctAnswer {
                button.backgroundColor = .systemGreen
            }
            button.isEnabled = false
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.flagView.image = image
            }
        }.resume()
    }

    private func findCorrectAnswerTitle() -> String? {
        return optionButtons.first(where: {
            $0.backgroundColor == .systemGreen
        })?.title(for: .normal)
    }
}
