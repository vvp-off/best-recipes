//
//  MyProfileViewProtocol.swift
//  Best Recipes
//
//  Created by Мария Родионова on 25.08.2025.
//


import Foundation
import UIKit

protocol MyProfileViewProtocol: AnyObject {

    func updateUI()
    func updateEmptyState()
    func updateCollectionViewHeight()
    func removeRecipe(at index: Int)
    

    func showImagePickerAlert()
    func presentImagePicker(sourceType: UIImagePickerController.SourceType)
    func updateProfileImage(_ image: UIImage)
    

    func showDeleteConfirmation(
        recipeName: String,
        at index: Int,
        completion: @escaping () -> Void
    )
}
