//
//  CreateRecipePresenterProtocol.swift
//  Best Recipes
//
//  Created by Иван Семенов on 25.08.2025.
//

import Foundation
import UIKit

protocol CreateRecipePresenterProtocol: AnyObject {
    var view: CreateRecipeViewProtocol? { get set }
    var router: MainRouterProtocol { get set }
    
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
    
    // Image handling
    func showImagePicker()
    func saveImage(_ image: UIImage) -> String?
    
    // Selection handlers
    func showServesSelector()
    func showTimeSelector()
    
    // Navigation
    func goBack()
}