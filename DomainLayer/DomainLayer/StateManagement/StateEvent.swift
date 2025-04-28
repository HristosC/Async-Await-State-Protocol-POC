//
//  StateEvent.swift
//  DomainLayer
//
//  Created by Christos Condrea on 12/2/25.
//

public enum StateEvent<Value: Codable>: Equatable {
    public static func == (lhs: StateEvent<Value>, rhs: StateEvent<Value>) -> Bool {
        lhs.equatableValue == rhs.equatableValue
    }
    
    case loading
    case success(Value)
    case failure(Error)
    case reset
    
  public var equatableValue: Int {
    switch self {
    case .loading:
      return 0
    case .success(let value):
      return 1
    case .failure(let error):
      return 2
    case .reset:
      return 3
    }
  }
  
}
extension StateEvent: Sendable where Value: Sendable {}
public struct StreamWrapper: Sendable {
    let continuation: AsyncStream<StateEvent<TodoList>>.Continuation
}
