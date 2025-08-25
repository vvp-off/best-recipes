
import UIKit

final class CreateRecipePresenter: CreateRecipePresenterProtocol {

    weak var view: CreateRecipeViewProtocol?

    private var currentServings = 3
    private var currentCookTime = 30
    private var selectedImage: UIImage?
    
    init(view: CreateRecipeViewProtocol) {
        self.view = view
    }

    func didSelectServes(_ serves: Int) {
        currentServings = serves
        let formattedValue = String(format: "%02d", serves)
        view?.updateServesValue(formattedValue)
    }
    
    func didSelectTime(_ minutes: Int, title: String) {
        currentCookTime = minutes
        view?.updateTimeValue(title)
    }
    
    func didTapCreateRecipe(title: String, ingredients: [ExtendedIngredient], instructions: String) {

        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            view?.showAlert(title: "Ошибка", message: "Введите название рецепта", completion: nil)
            return
        }
        
        guard !ingredients.isEmpty else {
            view?.showAlert(title: "Ошибка", message: "Добавьте хотя бы один ингредиент", completion: nil)
            return
        }
        
        guard !instructions.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            view?.showAlert(title: "Ошибка", message: "Добавьте инструкции приготовления", completion: nil)
            return
        }
        

        let recipe = createRecipeInfo(title: title, ingredients: ingredients, instructions: instructions)
        saveRecipe(recipe)
        
        view?.showAlert(title: "Готово", message: "Рецепт успешно сохранен") { [weak self] in
            self?.selectedImage = nil 
            self?.view?.clearAllFields()
        }
    }
    
    func didPickImage(_ image: UIImage) {
        selectedImage = image
        view?.setImage(image)
    }
    
    // MARK: - Private Methods
    
    private func createRecipeInfo(title: String, ingredients: [ExtendedIngredient], instructions: String) -> RecipeInfo {
        var imagePath: String?
        
        // Сохраняем изображение, если оно было выбрано
        if let image = selectedImage {
            imagePath = saveImageToDocuments(image: image)
        }
        
        let steps = [AnalyzedInstruction.Step(number: 1, step: instructions)]
        let analyzedInstructions = [AnalyzedInstruction(name: "Cooking", steps: steps)]
        
        return RecipeInfo(
            id: Int.random(in: 100000...999999),
            title: title,
            image: imagePath,
            readyInMinutes: currentCookTime,
            servings: currentServings,
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
            print("Failed to load saved recipes: \(error)")
            return []
        }
    }
    
    private func saveImageToDocuments(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Не удалось конвертировать изображение в JPEG")
            return nil
        }
        
        let fileName = "recipe_\(UUID().uuidString).jpg"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagePath = documentsPath.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: imagePath)
            return fileName
        } catch {
            print("Failed to save image: \(error)")
            return nil
        }
    }
}
