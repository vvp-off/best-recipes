//
//  MyProfilePresenter.swift
//  Best Recipes
//
//  Created by Мария Родионова on 25.08.2025.
//

import Foundation
import UIKit

class MyProfilePresenter: MyProfilePresenterProtocol {
    weak var view: MyProfileViewProtocol?
    
    private var recipes: [RecipeInfo] = []
    
    init(view: MyProfileViewProtocol) {
        self.view = view
    }
    
    // MARK: - Data Management
    
    func viewDidLoad() {
        loadRecipes()
        view?.updateUI()
    }
    
    func viewWillAppear() {
        loadRecipes()
        view?.updateUI()
    }
    
    func loadRecipes() {
        guard let data = UserDefaults.standard.data(forKey: "savedRecipes") else {
            recipes = []
            return
        }
        
        do {
            recipes = try JSONDecoder().decode([RecipeInfo].self, from: data)
        } catch {
            print("Ошибка загрузки рецептов из UserDefaults: \(error)")
            recipes = []
        }
    }
    
    func saveRecipes() {
        do {
            let data = try JSONEncoder().encode(recipes)
            UserDefaults.standard.set(data, forKey: "savedRecipes")
        } catch {
            print("Ошибка сохранения рецептов в UserDefaults: \(error)")
        }
    }
    
    // MARK: - Getters
    
    func getRecipesCount() -> Int {
        return recipes.count
    }
    
    func getRecipe(at index: Int) -> RecipeInfo? {
        guard index < recipes.count else { return nil }
        return recipes[index]
    }
    
    func isEmpty() -> Bool {
        return recipes.isEmpty
    }
    
    // MARK: - Recipe Management
    
    func deleteRecipe(at index: Int) {
        guard index < recipes.count else { return }
        let recipe = recipes[index]
        
        view?.showDeleteConfirmation(
            recipeName: recipe.title ?? "Без названия",
            at: index
        ) { [weak self] in
            self?.confirmDeleteRecipe(at: index)
        }
    }
    
    private func confirmDeleteRecipe(at index: Int) {
        guard index < recipes.count else { return }
        
        recipes.remove(at: index)
        saveRecipes()
        view?.removeRecipe(at: index)
        view?.updateUI()
    }
    
    // MARK: - Image Handling
    
    func changeProfileImage() {
        view?.showImagePickerAlert()
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        view?.presentImagePicker(sourceType: sourceType)
    }
    
    func updateProfileImage(_ image: UIImage) {
        view?.updateProfileImage(image)
    }
}
