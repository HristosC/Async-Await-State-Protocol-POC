//
//  InjectionImpl.swift
//  FirstApp
//
//  Created by Christos Condrea on 8/2/25.
//
import DomainLayer
import DataLayer
import PresentationLayer
import Swinject

public class AppDIImpl: AppDI {
    
    static let shared = AppDIImpl()
    
    private init() {}
    
    @MainActor let swinjectContainer: Container = {
        let container = Container()
        container.register(TodoRepository.self) { _ in
            TodoRepositoryImpl()
        }
        container.register(TodoUseCase.self) { resolver in
            return TodoUseCase(repository: resolver.resolve(TodoRepository.self)!)
        }
        container.register(TodoStateManager.self) { resolver in
            return TodoStateManager(useCase: resolver.resolve(TodoUseCase.self)!)
        }.inObjectScope(.container)
        return container
    }()
    
    @MainActor public func getContainer() -> Container {
        return swinjectContainer
    }

}
