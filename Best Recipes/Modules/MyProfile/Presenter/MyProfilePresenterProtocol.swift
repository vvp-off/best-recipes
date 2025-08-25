//
//  MyProfilePresenterProtocol.swift
//  Best Recipes
//
//  Created by Мария Родионова on 25.08.2025.
//


import Foundation
import UIKit

protocol MyProfilePresenterProtocol: AnyObject {
    var view: MyProfileViewProtocol? { get set }
    

    func viewDidLoad()
    func viewWillAppear()
    

    func loadRecipes()
    func saveRecipes()
    

    func getRecipesCount() -> Int
    func getRecipe(at index: Int) -> RecipeInfo?
    func isEmpty() -> Bool
    

    func deleteRecipe(at index: Int)
    

    func changeProfileImage()
    func presentImagePicker(sourceType: UIImagePickerController.SourceType)
    func updateProfileImage(_ image: UIImage)
}
