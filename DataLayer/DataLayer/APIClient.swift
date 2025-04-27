import Foundation

public protocol APIRequest {
    associatedtype Response: Decodable
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: String]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}



public struct NetworkError: Error {
    public let statusCode: Int
    public let message: String?
//    public let backendError: BackendError?
//    public let placesError: NetworkPlacesErrorResponse?
    public let underlyingError: Error?
}

public final class APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    public func send<T: Codable>(_ request: URLRequest) async throws -> T {
        return try await perform(request)
    }
    
    private func perform<T: Decodable>(_ urlRequest: URLRequest) async throws -> T {
        let (data, response) = try await performRequest(urlRequest)
        return try validate(response: response, data: data)
    }
    
    private func performRequest(_ urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(for: urlRequest)
        } catch {
            throw resolveRequestError(error)
        }
    }
    
    private func validate<T: Decodable>(
        response: URLResponse,
        data: Data
    ) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError(
                statusCode: 0,
                message: "Invalid response type",
//                backendError: nil,
//                placesError: nil,
                underlyingError: nil
            )
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            if data.isEmpty && T.self == VoidResponse.self {
                return VoidResponse() as! T
            }
            return try decoder.decode(T.self, from: data)
        default:
            throw resolveResponseError(
                statusCode: httpResponse.statusCode,
                data: data
            )
        }
    }
    
    private func resolveRequestError(_ error: Error) -> NetworkError {
        NetworkError(
            statusCode: 0,
            message: "Request failed",
//            backendError: nil,
//            placesError: nil,
            underlyingError: error
        )
    }
    
    private func resolveResponseError(
        statusCode: Int,
        data: Data
    ) -> NetworkError {
//        let backendError = try? decoder.decode(BackendError.self, from: data)
//        let placesError = try? decoder.decode(NetworkPlacesErrorResponse.self, from: data)
        let message = String(data: data, encoding: .utf8)
        
        return NetworkError(
            statusCode: statusCode,
            message: message,
//            backendError: backendError,
//            placesError: placesError,
            underlyingError: nil
        )
    }
}

public struct VoidResponse: Decodable {}
