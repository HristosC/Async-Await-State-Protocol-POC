//
//  NetworkConstants.swift
//  DataLayer
//
//  Created by Christos Condrea on 8/2/25.
//

struct NetworkConstants {
    static let baseURL = "https://jsonplaceholder.typicode.com"
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
