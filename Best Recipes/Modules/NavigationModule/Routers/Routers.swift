//
//  Routers.swift
//  Best Recipes
//
//  Created by Иван Семенов on 22.08.2025.
//

import UIKit

final class MainRouter: MainRouterProtocol {
    let navigationController: UINavigationController
    private let assembly: MainScreenAssembly
    
    init(navigationController: UINavigationController, assembly: MainScreenAssembly) {
        self.navigationController = navigationController
        self.assembly = assembly
    }
    
    func setupInitial() {
        let vc = assembly.createMainModule(router: self)
        navigationController.viewControllers = [vc]
    }
    
    func routeToDetailScreen(recipe: RecipeInfo) {
        let detailsVC = assembly.createDetailsModule(recipe: recipe)
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    func routeToSeeAllScreen(recipes: [RecipeProtocol], sortOrder: Endpoint.SortOrder) {
        let seeAllVC = assembly.createSeeAllModule(
            recipes: recipes,
            router: self,
            sortOrder: sortOrder
        )
        navigationController.pushViewController(seeAllVC, animated: true)
    }
}
