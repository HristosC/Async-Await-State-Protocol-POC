//
//  TodoRepositoryImpl.swift
//  DataLayer
//
//  Created by Christos Condrea on 8/2/25.
//

import DomainLayer

public struct TodoRepositoryImpl: TodoRepository {
    
    public init() {}
    
    public func fetch(number: Int) async throws -> TodoList {
        let request = try APIRequestBuilder.todos(number: number).makeURLRequest()
        let response: TodoList = try await APIClient().send(request)
        return response
    }
    
}
