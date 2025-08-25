//
//  CreateRecipeViewProtocol.swift
//  Best Recipes
//
//  Created by Мария Родионова on 25.08.2025.
//

import Foundation
import UIKit

protocol CreateRecipeViewProtocol: AnyObject {

    func showAlert(title: String, message: String)
    func showSuccessAlert(completion: @escaping () -> Void)
    

    func presentImagePickerAlert()
    func presentImagePicker(sourceType: UIImagePickerController.SourceType)
    

    func presentServesSelector(options: [Int], completion: @escaping (Int) -> Void)
    func presentTimeSelector(options: [(Int, String)], completion: @escaping (String) -> Void)
    

    func updateServesValue(_ serves: Int)
    func updateTimeValue(_ timeString: String)
    func clearAllFields()
    

    func collectIngredients() -> [ExtendedIngredient]
}
