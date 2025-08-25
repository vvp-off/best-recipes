//
//  Assembly.swift
//  Best Recipes
//
//  Created by Иван Семенов on 22.08.2025.
//

import UIKit

class Assembly: AssemblyProtocol {

    
    // TabBar
    func createTabBar() -> TabBarViewController {
        return TabBarViewController()
    }
    
    // Main Router
    func createMainRouter() -> MainRouterProtocol {
        let navVC = UINavigationController()
        navVC.tabBarItem = .init(title: nil, image: .tabBarItem1, tag: 0)
//        navVC.tabBarItem.selectedImage = .tabBarItem1Red
        let router = MainRouter(
            navigationController: navVC,
            assembly: self
        )
        router.setupInitial()
        return router
    }
    
    // HomeView
    func createMainModule(router: MainRouterProtocol) -> HomeViewController {
        let networkManager = NetworkManager.shared
        let presenter = HomePresenter(networkManager: networkManager, router: router)
        let homeVC = HomeViewController(presenter: presenter)
        
        return homeVC
    }
    
    // Details
    func createDetailsModule(recipe: RecipeInfo) -> RecipeDetailViewController {
        let recipeDetailsVC = RecipeDetailViewController(recipe: recipe)
        return recipeDetailsVC
    }

    // SeeAll
    func createSeeAllModule(recipes: [RecipeProtocol], router: MainRouterProtocol, sortOrder: Endpoint.SortOrder) -> SeeAllViewController {
        let networkManager = NetworkManager.shared
        let seeAllVC = SeeAllViewController()
        let presenter = SeeAllPresenter(
            view: seeAllVC,
            networkManager: networkManager,
            router: router,
            sortOrder: sortOrder,
            seeAllRecipes: recipes
        )
        seeAllVC.presenter = presenter
        return seeAllVC
    }
    
    func createFavoriteModule() -> FavoriteViewController {
        let viewController = FavoriteViewController()
        viewController.navigationItem.title = "Saved recipes"
        viewController.tabBarItem.image = .tabBarItem2
        return viewController
    }

    func createRecipeModule() -> CreateRecipeViewController {
        let view = CreateRecipeViewController()
        let presenter = CreateRecipePresenter(view: view)
        view.presenter = presenter
        return view
    }
    
    
    func myProfileModule() -> MyProfileViewController {
        let viewController = MyProfileViewController()
        let presenter = MyProfilePresenter(view: viewController)
        
        viewController.presenter = presenter
        viewController.navigationItem.title = "My Profile"
        viewController.tabBarItem.image = .tabBarItem4
        
        return viewController
    }
    
}
