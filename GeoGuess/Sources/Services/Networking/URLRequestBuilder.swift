import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case httpError(statusCode: Int)
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL encountered."
        case .noData: return "No data received from the server."
        case .httpError(let code): return "HTTP Error: Status code \(code)."
        case .decodingError(let error): return "Decoding failed: \(error.localizedDescription)"
        }
    }
}


struct URLRequestBuilder {
    private let baseURL = "https://restcountries.com"

    func build(from endpoint: Endpoint) throws -> URLRequest {
        var components = URLComponents(string: baseURL)
        components?.path = endpoint.path
        components?.queryItems = endpoint.queryItems

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return request
    }
} 
