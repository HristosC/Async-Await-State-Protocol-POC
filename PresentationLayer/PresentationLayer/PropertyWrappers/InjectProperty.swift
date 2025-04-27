//
//  InjectProperty.swift
//  PresentationLayer
//
//  Created by Christos Condrea on 16/2/25.
//

import Foundation
import Swinject

@propertyWrapper
@MainActor struct Inject<I> {
    public var wrappedValue: I?
    
    public init(named: String? = nil) {
        self.wrappedValue = Resolver.shared?.resolve(I.self, named)
    }
    
    public init(wrappedValue: I?) {
        self.wrappedValue = wrappedValue
    }
}
