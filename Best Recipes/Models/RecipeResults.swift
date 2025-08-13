//
//  RecipeResults.swift
//  Best Recipes
//
//  Created by Иван Семенов on 13.08.2025.
//

import Foundation

protocol RecipeProtocol {
    var id: Int { get }
    var title: String? { get }
    var image: String? { get }
    var rating: String? { get }
    var readyInMinutes: Int? { get }
    var extendedIngredients: [ExtendedIngredient]? { get }
    var instructionsLabel: String? { get }
}

struct RecipeResults: Codable {
    let results: [RecipeInfo]?
}

struct SearchRecipe: Codable, RecipeProtocol {
    let id: Int
    let title: String?
    let image: String?
    var rating: String?
    let readyInMinutes: Int?
    var extendedIngredients: [ExtendedIngredient]?
    var instructionsLabel: String?
}

struct RecipeInfo: Codable, RecipeProtocol {
    let id: Int
    let title: String?
    let image: String?
    let readyInMinutes: Int?
    let servings: Int?
    let aggregateLikes: Int?
    let sourceName: String?
    let dishTypes: [String]?
    let extendedIngredients: [ExtendedIngredient]?
    let analyzedInstructions: [AnalyzedInstruction]?
    
    var rating: String? {
        guard let likes = aggregateLikes else { return "❤️ 0"}
        switch likes {
        case 1000...:
            return "❤️ \(likes / 1000)k"
        default:
            return "❤️ \(likes)"
        }
    }
    
    var instructionsLabel: String? {
        var result: String = ""
        guard let instructions = analyzedInstructions?.first else { return "" }
        instructions.steps?.forEach {
            result.append(contentsOf: "\($0.number ?? 1). \($0.step ?? "").\n")
        }
        return result
    }
}

struct ExtendedIngredient: Codable {
    let id: Int?
    let imageIngredient: String?
    let name: String?
    let unit: String?
    let amount: Double?
    var imageURL: String {
        "https://spoonacular.com/cdn/ingredients_100x100/\(imageIngredient ?? "")"
    }
}

struct AnalyzedInstruction: Codable {
    let name: String?
    let steps: [Step]?
    
    struct Step: Codable {
        let number: Int?
        let step: String?
    }
}
