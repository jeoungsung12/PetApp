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
    func registerSingleton<T>(type: T.Type, factory: @escaping () -> T)
    func registerFactory<T>(type: T.Type, factory: @escaping (DIContainerType) -> T)
    func registerFactoryWithEntity<T, E>(type: T.Type, factory: @escaping (DIContainerType, E) -> T)
    func resolveFactory<T>(type: T.Type) -> T?
    func resolveFactory<T, E>(type: T.Type, entity: E) -> T?
}

final class DIContainer: DIContainerType {
    static let shared: DIContainerType = DIContainer()
    
    private init() {}
    
    private var components: [String: Any] = [:]
    
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
    
    func registerFactoryWithEntity<T, E>(type: T.Type, factory: @escaping (DIContainerType, E) -> T) {
        let key = "\(String(describing: type))_entity"
        components[key] = factory
    }
    
    func resolveFactory<T>(type: T.Type) -> T? {
        let key = String(describing: type)
        if let factory = components[key] as? (DIContainerType) -> T {
            return factory(self)
        }
        return nil
    }
    
    func resolveFactory<T, E>(type: T.Type, entity: E) -> T? {
        let key = "\(String(describing: type))_entity"
        if let factory = components[key] as? (DIContainerType, E) -> T {
            return factory(self, entity)
        }
        return nil
    }
}

extension DIContainer {
    static func setupDependencies() {
        let container = DIContainer.shared
        
        container.registerSingleton(type: NetworkManagerType.self) {
            NetworkManager.shared
        }
        
        container.registerSingleton(type: NetworkMonitorManagerType.self) {
            NetworkMonitorManager()
        }
        
        container.registerSingleton(type: LocationRepositoryType.self) {
            LocationRepository.shared
        }
        
        container.registerSingleton(type: NetworkRepositoryType.self) {
            NetworkRepository.shared
        }
        
        container.registerSingleton(type: RealmRepositoryType.self) {
            RealmRepository.shared
        }
        
        container.registerFactory(type: SponsorViewModel.self) { _ in
            SponsorViewModel()
        }
        
        container.registerFactory(type: RecordViewModel.self) { _ in
            RecordViewModel()
        }
        
        container.registerFactory(type: WriteViewModel.self) { _ in
            WriteViewModel()
        }
        
        container.registerFactory(type: RecordTableViewModel.self) { _ in
            RecordTableViewModel()
        }
        
        container.registerFactory(type: ListTableViewModel.self) { _ in
            ListTableViewModel()
        }
        
        container.registerFactory(type: ErrorViewModel.self) { _ in
            ErrorViewModel(notiType: .none)
        }
        
        container.registerFactory(type: ProfileViewModel.self) { container in
            ProfileViewModel(db: container.resolve(type: RealmRepositoryType.self)!)
        }
        
        container.registerFactory(type: PlayerViewModel.self) { container in
            PlayerViewModel(repository: container.resolve(type: NetworkRepositoryType.self)!)
        }
        
        container.registerFactory(type: PhotoViewModel.self) { container in
            PhotoViewModel(
                locationRepo: container.resolve(type: LocationRepositoryType.self)!,
                repository: container.resolve(type: NetworkRepositoryType.self)!
            )
        }
        
        container.registerFactory(type: MyPageViewModel.self) { container in
            MyPageViewModel(realm: container.resolve(type: RealmRepositoryType.self)!)
        }
        
        container.registerFactory(type: MapViewModel.self) { container in
            MapViewModel(
                repository: container.resolve(type: NetworkRepositoryType.self)!,
                locationManager: container.resolve(type: LocationRepositoryType.self)!,
                mapType: .shelter
            )
        }
        
        container.registerFactory(type: ListViewModel.self) { container in
            ListViewModel(repository: container.resolve(type: NetworkRepositoryType.self)!)
        }
        
        container.registerFactory(type: LikeViewModel.self) { container in
            LikeViewModel(realmRepo: container.resolve(type: RealmRepositoryType.self)!)
        }
        
        container.registerFactory(type: HomeViewModel.self) { container in
            HomeViewModel(repository: container.resolve(type: NetworkRepositoryType.self)!)
        }
        
        container.registerFactory(type: ChatViewModel.self) { container in
            ChatViewModel(
                realmRepo: container.resolve(type: RealmRepositoryType.self)!,
                repository: container.resolve(type: NetworkRepositoryType.self)!
            )
        }
        
        container.registerFactoryWithEntity(type: DetailViewModel.self) { _, entity in
            DetailViewModel(model: entity)
        }
        
        container.registerFactoryWithEntity(type: DetailMiddleViewModel.self) { container, entity in
            DetailMiddleViewModel(
                repo: container.resolve(type: RealmRepositoryType.self)!,
                entity: entity
            )
        }
        
        container.registerFactoryWithEntity(type: ChatDetailViewModel.self) { container, entity in
            ChatDetailViewModel(
                repository: container.resolve(type: NetworkRepositoryType.self)!,
                entity: entity
            )
        }
    }
}
