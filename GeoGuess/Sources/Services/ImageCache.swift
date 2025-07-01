import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSURL, UIImage>()

    private init() {}

    func image(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }

    func save(image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
} 