
import UIKit

protocol CreateRecipeViewProtocol: AnyObject {
    func showAlert(title: String, message: String, completion: (() -> Void)?)
    func clearAllFields()
    func updateServesValue(_ value: String)
    func updateTimeValue(_ value: String)
    func setImage(_ image: UIImage)
    func resetToDefaultImage()
}

protocol CreateRecipePresenterProtocol: AnyObject {
    func didSelectServes(_ serves: Int)
    func didSelectTime(_ minutes: Int, title: String)
    func didTapCreateRecipe(title: String, ingredients: [ExtendedIngredient], instructions: String)
    func didPickImage(_ image: UIImage)
}
