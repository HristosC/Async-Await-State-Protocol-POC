//
//  CancellableTask.swift
//  PresentationLayer
//
//  Created by Christos Condrea on 17/2/25.
//

@propertyWrapper
public struct CancellableTask : ~Copyable {
    private var task: Task<Void, Never>?
    
    public var wrappedValue: Task<Void, Never>? {
        get { task }
        set { task = newValue }
    }
    
    public init(wrappedValue: Task<Void, Never>? = nil) {
        self.task = wrappedValue
    }
    
    public mutating func cancel() {
        task?.cancel()
        task = nil
    }
    
    deinit {
        task?.cancel()
    }
}
