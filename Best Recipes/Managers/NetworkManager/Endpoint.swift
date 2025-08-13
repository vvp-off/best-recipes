//
//  Endpoint.swift
//  Best Recipes
//
//  Created by Иван Семенов on 12.08.2025.
//

import Foundation

enum Endpoint {
    case getRecipeInfo(id: Int)
    case getRandomRecipes
    case searchRecipes
    case getPopularRecipes
    case getRecipesForMealType(type: String)
    case getRecipeInfoBulk(idRecipes: [Int])
    
    var path: String {
        switch self {
        case .getRecipeInfo(let id):
            return "/recipes/\(id)/information"
        case .getRandomRecipes:
            return "/recipes/random"
        case .searchRecipes:
            return "/recipes/complexSearch"
        case .getPopularRecipes:
            return "/recipes/complexSearch"
        case .getRecipesForMealType(let type):
            return "/recipes/complexSearch"
        case .getRecipeInfoBulk(let idRecipes):
            return "/recipes/informationBulk"
        }
    }
}

extension Endpoint {
    enum SortOrder: String {
        case trendingNow
        case random
        
        var title: String {
            switch self {
            case .trendingNow:
                return "Trending now"
            case .random:
                return "Random recipe"
            }
        }
    }
}
