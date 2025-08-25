//
//  CreateRecipePresenter.swift
//  Best Recipes
//
//  Created by Иван Семенов on 25.08.2025.
//

import Foundation
import UIKit

class CreateRecipePresenter: CreateRecipePresenterProtocol {
    weak var view: CreateRecipeViewProtocol?
    var router: MainRouterProtocol
    
    init(
        view: CreateRecipeViewProtocol,
        router: MainRouterProtocol
    ) {
        self.view = view
        self.router = router
    }
    
    // MARK: - Recipe Creation
    
    func createRecipe(
        title: String,
        image: UIImage?,
        serves: Int,
        cookTime: Int,
        ingredients: [ExtendedIngredient],
        instructions: String
    ) {
        guard validateRecipeData(title: title, ingredients: ingredients, instructions: instructions) else {
            return
        }
        
        let recipe = buildRecipeInfo(
            title: title,
            image: image,
            serves: serves,
            cookTime: cookTime,
            ingredients: ingredients,
            instructions: instructions
        )
        
        saveRecipe(recipe)
        view?.showSuccessAlert {
            self.view?.clearAllFields()
            self.router.popViewController()
        }
    }
    
    func validateRecipeData(title: String, ingredients: [ExtendedIngredient], instructions: String) -> Bool {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            view?.showAlert(title: "Ошибка", message: "Введите название рецепта")
            return false
        }
        
        if ingredients.isEmpty {
            view?.showAlert(title: "Ошибка", message: "Добавьте хотя бы один ингредиент")
            return false
        }
        
        if instructions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            view?.showAlert(title: "Ошибка", message: "Добавьте инструкции приготовления")
            return false
        }
        
        return true
    }
    
    // MARK: - Image Handling
    
    func showImagePicker() {
        view?.presentImagePickerAlert()
    }
    
    func saveImage(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        let fileName = "recipe_\(UUID().uuidString).jpg"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagePath = documentsPath.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: imagePath)
            return fileName
        } catch {
            return nil
        }
    }
    
    // MARK: - Selection Handlers
    
    func showServesSelector() {
        let servesOptions = [1, 2, 3, 4, 5, 6, 8, 10, 12]
        view?.presentServesSelector(options: servesOptions) { [weak self] serves in
            self?.view?.updateServesValue(serves)
        }
    }
    
    func showTimeSelector() {
        let timeOptions = [
            (10, "10 min"), (15, "15 min"), (20, "20 min"), (25, "25 min"), (30, "30 min"),
            (45, "45 min"), (60, "1 час"), (90, "1.5 часа"), (120, "2 часа"), (180, "3 часа")
        ]
        view?.presentTimeSelector(options: timeOptions) { [weak self] timeString in
            self?.view?.updateTimeValue(timeString)
        }
    }
    
    func goBack() {
        router.popViewController()
    }
    
    // MARK: - Private Methods
    
    private func buildRecipeInfo(
        title: String,
        image: UIImage?,
        serves: Int,
        cookTime: Int,
        ingredients: [ExtendedIngredient],
        instructions: String
    ) -> RecipeInfo {
        var imagePath: String?
        if let image = image {
            imagePath = saveImage(image)
        }
        
        let steps = [AnalyzedInstruction.Step(number: 1, step: instructions)]
        let analyzedInstructions = [AnalyzedInstruction(name: "Cooking", steps: steps)]
        
        return RecipeInfo(
            id: Int.random(in: 100000...999999),
            title: title,
            image: imagePath,
            readyInMinutes: cookTime,
            servings: serves,
            aggregateLikes: 0,
            sourceName: "My Recipe",
            dishTypes: ["custom"],
            analyzedInstructions: analyzedInstructions,
            extendedIngredients: ingredients
        )
    }
    
    private func saveRecipe(_ recipe: RecipeInfo) {
        var savedRecipes = getSavedRecipes()
        savedRecipes.append(recipe)
        
        do {
            let data = try JSONEncoder().encode(savedRecipes)
            UserDefaults.standard.set(data, forKey: "savedRecipes")
        } catch {
            print("Failed to save recipe: \(error)")
        }
    }
    
    private func getSavedRecipes() -> [RecipeInfo] {
        guard let data = UserDefaults.standard.data(forKey: "savedRecipes") else { return [] }
        
        do {
            return try JSONDecoder().decode([RecipeInfo].self, from: data)
        } catch {
            return []
        }
    }
}