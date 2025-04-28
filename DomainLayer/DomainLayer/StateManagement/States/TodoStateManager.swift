//
//  TodoStateManager.swift
//  DomainLayer
//
//  Created by Christos Condrea on 12/2/25.
//

protocol TodoStateManagerProtocol: StateManagerProtocol where Value == TodoList {}

@MainActor // Entire class isolated to MainActor
public final class TodoStateManager: TodoStateManagerProtocol {
    // MARK: - Protocol Requirements
    public private(set) var currentValue: TodoList?
    private let useCase: TodoUseCase
    public var continuations = [UUID: AsyncStream<StateEvent<TodoList>>.Continuation]()
    
    // MARK: - Stream Implementation
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
    
    // MARK: - Initialization
    public init(useCase: TodoUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Public Interface
    public func refresh() async throws -> TodoList {
        notify(.loading)
        
        do {
            let list = try await useCase.getTodoList(at: 1)
            update(with: list)
            return list
        } catch {
            notify(.failure(error))
            throw error
        }
    }
    
    public func update(with value: TodoList) {
        currentValue = value
        notify(.success(value))
    }
    
    public func reset() {
        currentValue = nil
        notify(.reset)
    }
    
    // MARK: - Private Helpers
    private func notify(_ event: StateEvent<TodoList>) {
        continuations.values.forEach { $0.yield(event) }
    }
    
    public func fetch(at offset: Int) async throws {
        notify(.loading)
        
        do {
            let list = try await useCase.getTodoList(at: offset)
            update(with: list)
            
        } catch {
            notify(.failure(error))
            throw error
        }
    }
}
