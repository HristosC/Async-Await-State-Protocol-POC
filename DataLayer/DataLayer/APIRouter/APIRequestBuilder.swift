//
//  APIRequestBuilder.swift
//  DataLayer
//
//  Created by Christos Condrea on 8/2/25.
//

enum APIRequestBuilder {
    
    func makeURLRequest() throws -> URLRequest {
        guard let url = URL(string: NetworkConstants.baseURL)?.appending(path: path, directoryHint: .notDirectory) else {
            throw URLError(.badURL)
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let finalURL = components.url else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }

    
    case todos(number: Int)
    
    var path: String {
        switch self {
        case let .todos(number):
            return "/todos/\(number)"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .todos:
            return .get
        }
    }
    
    private var parameters: [String: String]? {
        switch self {
        case let .todos(number):
            return nil
        }
    }
    
    private var headers: [String: String]? {
        return nil
    }
    
}
