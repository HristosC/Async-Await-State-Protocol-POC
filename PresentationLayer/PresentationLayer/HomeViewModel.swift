//
//  HomeViewModel.swift
//  PresentationLayer
//
//  Created by Christos Condrea on 13/2/25.
//

import DomainLayer

@MainActor
public final class HomeViewModel: ObservableObject {
    @Published private(set) var state: StateEvent<TodoList> = .loading
    @Inject private final var stateManager: TodoStateManager?
    @CancellableTask private var observationTask
    
    public init() {
        setupObservation()
    }
    
    private func setupObservation() {
        _observationTask.wrappedValue = Task { [weak self] in
            guard let stream = self?.stateManager?.stateStream else { return }
            
            for await event in stream {
                await MainActor.run {
                    self?.state = event
                }
            }
        }
    }
    
    private func start() async {
        do { _ = try await self.stateManager?.refresh() } catch {}
    }
    
    public func fetch(at offset: Int) async {
        do { try await self.stateManager?.fetch(at: offset) } catch {}
    }
    
}


@MainActor
public final class SecondViewModel: ObservableObject {
    @Published private(set) var state: StateEvent<TodoList> = .loading
    @Inject private final var stateManager: TodoStateManager?
    @CancellableTask private var observationTask
    
    public init() {
        setupObservation()
    }
    
    private func setupObservation() {
        _observationTask.wrappedValue = Task { [weak self] in
            guard let stream = self?.stateManager?.stateStream else { return }
            
            for await event in stream {
                await MainActor.run {
                    self?.state = event
                }
            }
        }
    }
    
    private func start() async {
        do { _ = try await self.stateManager?.refresh() } catch {}
    }
    
    public func fetch(at offset: Int) async {
        do { try await self.stateManager?.fetch(at: offset) } catch {}
    }
    
}
