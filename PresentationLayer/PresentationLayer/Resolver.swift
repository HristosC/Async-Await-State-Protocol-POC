//
//  Resolver.swift
//  PresentationLayer
//
//  Created by Christos Condrea on 16/2/25.
//

import Swinject

@MainActor public final class Resolver {
    private let appDI: AppDI
    private let container: Container
    
    public static var shared: Resolver? = nil
    
    public init(appDI: AppDI) {
        self.appDI = appDI
        self.container = appDI.getContainer()
    }
        
    func resolve<T>(_ type: T.Type, _ name: String? = nil) -> T? {
        return container.resolve(T.self, name: name)
    }
}
