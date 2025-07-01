import Foundation

struct NetworkManager {
    private let session: URLSession
    private let requestBuilder = URLRequestBuilder()
    private let responseHandler = ResponseHandler()

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20.0
        self.session = URLSession(configuration: configuration)
    }

    func perform<T: Decodable>(endpoint: Endpoint) async throws -> T {
        
        let request = try requestBuilder.build(from: endpoint)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidURL
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }
        
        return try responseHandler.decode(from: data)
    }
} 
