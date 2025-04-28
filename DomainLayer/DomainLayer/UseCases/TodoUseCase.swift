//
//  TodoUseCase.swift
//  DomainLayer
//
//  Created by Christos Condrea on 8/2/25.
//

final public class TodoUseCase: Sendable {
    private let repository: TodoRepository
    
    public init(repository: TodoRepository) {
        self.repository = repository
    }
    
    public func getTodoList(at number: Int) async throws -> TodoList {
        return try await repository.fetch(number: number)
    }
    
}
