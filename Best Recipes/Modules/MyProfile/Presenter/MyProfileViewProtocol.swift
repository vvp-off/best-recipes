//
//  MyProfileViewProtocol.swift
//  Best Recipes
//
//  Created by Иван Семенов on 25.08.2025.
//

import Foundation
import UIKit

protocol MyProfileViewProtocol: AnyObject {
    // UI updates
    func updateUI()
    func updateEmptyState()
    func updateCollectionViewHeight()
    func removeRecipe(at index: Int)
    
    // Image handling
    func showImagePickerAlert()
    func presentImagePicker(sourceType: UIImagePickerController.SourceType)
    func updateProfileImage(_ image: UIImage)
    
    // Alerts
    func showDeleteConfirmation(
        recipeName: String,
        at index: Int,
        completion: @escaping () -> Void
    )
}