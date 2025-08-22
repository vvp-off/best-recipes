//
//  SeeAllPresenter.swift
//  Best Recipes
//
//  Created by Иван Семенов on 14.08.2025.
//

import Foundation

class SeeAllPresenter: SeeAllPresenterProtocol {
    weak var view: SeeAllViewProtocol?
    var networkManager: NetworkManager
    var router: MainRouterProtocol
    
    var sortOrder: Endpoint.SortOrder
    var seeAllRecipes: [RecipeProtocol]
    
    init(
        view: SeeAllViewProtocol,
        networkManager: NetworkManager,
        router: MainRouterProtocol,
        sortOrder: Endpoint.SortOrder,
        seeAllRecipes: [RecipeProtocol]
    ) {
        self.view = view
        self.networkManager = networkManager
        self.router = router
        self.sortOrder = sortOrder
        self.seeAllRecipes = seeAllRecipes
    }
}
