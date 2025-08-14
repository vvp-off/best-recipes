//
//  SeeAllPresenterProtocol.swift
//  Best Recipes
//
//  Created by Иван Семенов on 14.08.2025.
//

import Foundation

protocol SeeAllPresenterProtocol: AnyObject {
    var view: SeeAllViewProtocol? { get set }
    var sortOrder: Endpoint.SortOrder { get set }
    var seeAllRecipes: [RecipeProtocol] { get set }
    
    var networkManager: NetworkManager { get set }
}

