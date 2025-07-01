import UIKit

class LoadingImageView: UIImageView {
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func loadImage(from url: URL?) {
        image = nil
        
        guard let url = url else {
            image = UIImage(systemName: Constants.Icons.photo)
            return
        }

        if let cachedImage = ImageCache.shared.image(for: url) {
            self.image = cachedImage
            return
        }
        
        activityIndicator.startAnimating()

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                guard let data = data, let newImage = UIImage(data: data) else {
                    self?.image = UIImage(systemName: Constants.Icons.photo)
                    return
                }
                ImageCache.shared.save(image: newImage, for: url)
                self?.image = newImage
            }
        }.resume()
    }
} 
