//
//  DependenciesProvider.swift
//  YMapsIntergation
//
//  Created by Amir on 22.03.2025.
//

import Foundation
import Swinject

final class DependenciesProvider {
    private static let container = Container(defaultObjectScope: .container)
    private static let viewsContainer = Container(parent: container, defaultObjectScope: .transient)
    
    private init() { }
    
    static func RegisterDependencies() {
        registerManagers()
        registerViews()
    }
    
    static func Resolve<T>(_ type: T.Type) -> T?  {
        let resolved = container.resolve(type)
        
        return resolved
    }
    
    static func ResolveView<T>(_ type: T.Type) -> T? where T: UIViewController {
        let resolved = viewsContainer.resolve(type)
        
        return resolved
    }
    
    private static func registerManagers() {
        container.register(SearchManager.self, factory: { r in MapSearchManager() })
        container.register(AddressManager.self, factory: { r in MapAddressManager() })
    }
    
    private static func registerViews() {
        viewsContainer.register(MapView.self, factory: { r in MapView() })
        viewsContainer.register(FavouriteAddressesView.self, factory: { r in FavouriteAddressesView(r.resolve(AddressManager.self)!) })
    }
}
