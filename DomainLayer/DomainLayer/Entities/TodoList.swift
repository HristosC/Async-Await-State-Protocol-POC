//
//  TodoList.swift
//  DomainLayer
//
//  Created by Christos Condrea on 8/2/25.
//

public struct TodoList: Codable, Sendable {
    public let userId: Int
    public let id: Int
    public let title: String
    public let completed: Bool
}
