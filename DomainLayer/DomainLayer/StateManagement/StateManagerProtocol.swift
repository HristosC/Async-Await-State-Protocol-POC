//
//  StateManagerProtocol.swift
//  DomainLayer
//
//  Created by Christos Condrea on 9/2/25.
//

@MainActor public protocol StateManagerProtocol: AnyObject, Sendable {
    associatedtype Value: Codable
    
    /// Current state value (always matches last .success case)
    @MainActor var currentValue: Value? { get }
    
    /// Refresh from remote source (optional throw)
    func refresh() async throws -> Value
    
    /// Local state update
    @MainActor func update(with value: Value) async
    
    /// Reset to initial state
    @MainActor func reset() async
    var continuations: [UUID: AsyncStream<StateEvent<Value>>.Continuation] { get set }
    var stateStream: AsyncStream<StateEvent<Value>> { get }
}

extension TodoStateManagerProtocol {
    public nonisolated var stateStream: AsyncStream<StateEvent<TodoList>> {
        AsyncStream { continuation in
            let id = UUID()
            
            // Store continuation immediately with proper isolation
            Task { @MainActor in
                // Initial state emission
                if let value = self.currentValue {
                    continuation.yield(.success(value))
                } else {
                    continuation.yield(.reset)
                }
                
                // Store continuation reference
                self.continuations[id] = continuation
                
                // Setup termination handler with proper isolation
                continuation.onTermination = { _ in
                    Task { @MainActor in
                        self.continuations.removeValue(forKey: id)
                    }
                }
            }
        }
    }
}
