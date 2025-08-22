//
//  AssemblyProtocol.swift
//  Best Recipes
//
//  Created by Иван Семенов on 22.08.2025.
//

import Foundation

protocol RootAssembly {
    func createTabBar() -> TabBarViewController
    func createMainRouter() -> MainRouterProtocol
}

protocol MainScreenAssembly {
    func createMainModule(router: MainRouterProtocol) -> HomeViewController
    func createSeeAllModule(recipes: [RecipeProtocol], router: MainRouterProtocol, sortOrder: Endpoint.SortOrder) -> SeeAllViewController
    
}

typealias AssemblyProtocol = RootAssembly & MainScreenAssembly
