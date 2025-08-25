//
//  CreateRecipeViewProtocol.swift
//  Best Recipes
//
//  Created by Иван Семенов on 25.08.2025.
//

import Foundation
import UIKit

protocol CreateRecipeViewProtocol: AnyObject {
    // Alert methods
    func showAlert(title: String, message: String)
    func showSuccessAlert(completion: @escaping () -> Void)
    
    // Image picker methods
    func presentImagePickerAlert()
    func presentImagePicker(sourceType: UIImagePickerController.SourceType)
    
    // Selection methods
    func presentServesSelector(options: [Int], completion: @escaping (Int) -> Void)
    func presentTimeSelector(options: [(Int, String)], completion: @escaping (String) -> Void)
    
    // UI update methods
    func updateServesValue(_ serves: Int)
    func updateTimeValue(_ timeString: String)
    func clearAllFields()
    
    // Ingredient collection
    func collectIngredients() -> [ExtendedIngredient]
}