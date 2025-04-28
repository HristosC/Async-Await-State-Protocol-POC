//
//  TodoRepository.swift
//  DomainLayer
//
//  Created by Christos Condrea on 8/2/25.
//

public protocol TodoRepository: Sendable {
     func fetch(number: Int) async throws -> TodoList
}
