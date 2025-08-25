//
//  CreateRecipePresenterProtocol.swift
//  Best Recipes
//
//  Created by Мария Родионова on 25.08.2025.
//


import Foundation
import UIKit

protocol CreateRecipePresenterProtocol: AnyObject {
    var view: CreateRecipeViewProtocol? { get set }
    
    // Recipe creation methods
    func createRecipe(
        title: String,
        image: UIImage?,
        serves: Int,
        cookTime: Int,
        ingredients: [ExtendedIngredient],
        instructions: String
    )
    
    func validateRecipeData(
        title: String,
        ingredients: [ExtendedIngredient],
        instructions: String
    ) -> Bool
    

    func showImagePicker()
    func saveImage(_ image: UIImage) -> String?
    

    func showServesSelector()
    func showTimeSelector()
}
