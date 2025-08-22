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
    case getRecipesForMealType(type: MealType)
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
        case .getRecipesForMealType(type: _):
            return "/recipes/complexSearch"
        case .getRecipeInfoBulk(idRecipes: _):
            return "/recipes/informationBulk"
        }
    }
}

extension Endpoint {
    enum SortOrder: String {
        case trendingNow
        case popular
        case recent
        case random
        
        var title: String {
            switch self {
            case .trendingNow:
                return "Trending now 🔥"
            case .random:
                return "Random recipe"
            case .popular:
                return "Popular recipes"
            case .recent:
                return "Recent recipes"
            }
        }
    }
}
