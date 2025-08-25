//
//  MyProfilePresenterProtocol.swift
//  Best Recipes
//
//  Created by Иван Семенов on 25.08.2025.
//

import Foundation
import UIKit

protocol MyProfilePresenterProtocol: AnyObject {
    var view: MyProfileViewProtocol? { get set }
    
    // Lifecycle methods
    func viewDidLoad()
    func viewWillAppear()
    
    // Data management
    func loadRecipes()
    func saveRecipes()
    
    // Getters
    func getRecipesCount() -> Int
    func getRecipe(at index: Int) -> RecipeInfo?
    func isEmpty() -> Bool
    
    // Recipe management
    func deleteRecipe(at index: Int)
    
    // Image handling
    func changeProfileImage()
    func presentImagePicker(sourceType: UIImagePickerController.SourceType)
    func updateProfileImage(_ image: UIImage)
}