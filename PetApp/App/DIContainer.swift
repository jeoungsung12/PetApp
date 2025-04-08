//
//  DIContainer.swift
//  PetApp
//
//  Created by 정성윤 on 4/8/25.
//

import Foundation

protocol DIContainerType: AnyObject {
    func register<T>(type: T.Type, component: Any)
    func resolve<T>(type: T.Type) -> T?
}

final class DIContainer: DIContainerType {
    private let shared: DIContainerType = DIContainer()
    
    private init() { }
    
    private var components: [String:Any] = [:]
    
    func register<T>(type: T.Type, component: Any) {
        let key = String(describing: type)
        components[key] = component
    }
    
    func resolve<T>(type: T.Type) -> T? {
        let key = String(describing: type)
        return components[key] as? T
    }
    
    func registerSingleton<T>(type: T.Type, factory: @escaping () -> T) {
        let instance = factory()
        register(type: type, component: instance)
    }
    
    func registerFactory<T>(type: T.Type, factory: @escaping (DIContainerType) -> T) {
        register(type: type, component: factory)
    }
    
    func resolveFactory<T>(type: T.Type) -> T? {
        let key = String(describing: type)
        if let factory = components[key] as? (DIContainerType) -> T {
            return factory(self)
        }
        return nil
    }
    
}
