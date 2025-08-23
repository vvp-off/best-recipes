//
//  RouterProtocol.swift
//  Best Recipes
//
//  Created by Иван Семенов on 22.08.2025.
//

import UIKit

protocol BaseRouterProtocol: AnyObject {
    var navigationController: UINavigationController { get }
    func routeToDetailScreen(recipe: RecipeInfo)
}

protocol MainRouterProtocol: BaseRouterProtocol {
    func routeToSeeAllScreen(recipes: [RecipeProtocol], sortOrder: Endpoint.SortOrder)
}

protocol SearchRouterProtocol: BaseRouterProtocol { }

protocol SavedRecipesRouterProtocol: BaseRouterProtocol { }

protocol ProfileRouterProtocol: BaseRouterProtocol { }

protocol CreateRouterProtocol: BaseRouterProtocol { }
