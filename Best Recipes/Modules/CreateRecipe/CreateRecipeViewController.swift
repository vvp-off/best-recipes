//
//  CreateRecipeViewController.swift
//  Best Recipes
//
//  Created by Мария Родионова on 25.08.2025.
//

import UIKit

final class CreateRecipeViewController: UIViewController {
    enum Layout {
        static let contentInset: CGFloat = 16
        static let bottomInset: CGFloat = 50
        static let imageHeight: CGFloat = 180
        static let changeButtonSize: CGFloat = 32
        static let changeButtonInset: CGFloat = 8
        static let titleFieldHeight: CGFloat = 44
        static let instructionsHeight: CGFloat = 120
        static let createButtonHeight: CGFloat = 50
    }

    var presenter: CreateRecipePresenterProtocol!
    
    private let servesRow = InfoRow(icon: UIImage(resource: .iconServes), title: "Serves", value: "03")
    private let timeRow = InfoRow(icon: UIImage(resource: .iconServesClock), title: "Cook time", value: "20 min")

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentStack: UIStackView = {
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        return contentStack
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .media)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let changeImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .edit), for: .normal)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        button.tintColor = .black
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleField: UITextField = {
        let titleField = UITextField()
        titleField.placeholder = "Recipe title"
        titleField.font = .systemFont(ofSize: 18, weight: .medium)
        titleField.borderStyle = .none
        titleField.tintColor = .systemRed
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 40))
        titleField.leftView = paddingView
        titleField.leftViewMode = .always
        titleField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 40))
        titleField.rightViewMode = .always
        
        titleField.layer.borderColor = UIColor.red.cgColor
        titleField.layer.borderWidth = 1.0
        titleField.layer.cornerRadius = 8.0
        
        return titleField
    }()
    
    private let ingredientsTitle: UILabel = {
        let ingredientsTitle = UILabel()
        ingredientsTitle.text = "Ingredients"
        ingredientsTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        return ingredientsTitle
    }()
    
    private let ingredientsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private let instructionsTitle: UILabel = {
        let instructionsTitle = UILabel()
        instructionsTitle.text = "Instructions"
        instructionsTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        return instructionsTitle
    }()
    
    private let instructionsTextView: UITextView = {
        let instructionsTextView = UITextView()
        instructionsTextView.font = .systemFont(ofSize: 16)
        instructionsTextView.textColor = .placeholderText
        instructionsTextView.text = "Write cooking instructions..."
        instructionsTextView.layer.borderColor = UIColor.systemGray4.cgColor
        instructionsTextView.layer.borderWidth = 1
        instructionsTextView.layer.cornerRadius = 8
        instructionsTextView.isScrollEnabled = true
        instructionsTextView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        return instructionsTextView
    }()
    
    private let createButton: UIButton = {
        let createButton = UIButton(type: .system)
        createButton.setTitle("Create recipe", for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        createButton.backgroundColor = .systemRed
        createButton.setTitleColor(.white, for: .normal)
        createButton.layer.cornerRadius = 10
        return createButton
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        addSubviews()
        setupConstraints()
        setupIngredients()
        setupActions()
        instructionsTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    
    private func setupNavigationBar() {
        navigationItem.title = "Create recipe"
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupActions() {
        changeImageButton.addTarget(self, action: #selector(didTapChangeImage), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateRecipe), for: .touchUpInside)
        
        servesRow.addTapGesture { [weak self] in
            self?.showServesSelector()
        }
        
        timeRow.addTapGesture { [weak self] in
            self?.showTimeSelector()
        }
    }
    
    private func setupIngredients() {
        addIngredient(name: "Pasta", quantity: "250gr")
        addNewIngredientRow()
    }

    @objc private func didTapChangeImage() {
        let alert = UIAlertController(
            title: "Сменить изображение",
            message: "Выберите способ смены изображения",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Камера", style: .default) { _ in
            self.presentImagePicker(sourceType: .camera)
        })
        
        alert.addAction(UIAlertAction(title: "Галерея", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
    @objc private func didTapCreateRecipe() {
        guard let title = titleField.text else { return }
        
        let ingredients = collectIngredients()
        let instructions = instructionsTextView.textColor == .placeholderText ? "" : instructionsTextView.text ?? ""
        
        presenter.didTapCreateRecipe(title: title, ingredients: ingredients, instructions: instructions)
    }
    
    private func showServesSelector() {
        let alert = UIAlertController(
            title: "Количество порций",
            message: "Выберите количество порций",
            preferredStyle: .actionSheet
        )
        
        for serves in [1, 2, 3, 4, 5, 6, 8, 10, 12] {
            alert.addAction(UIAlertAction(title: "\(serves)", style: .default) { _ in
                self.presenter.didSelectServes(serves)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showTimeSelector() {
        let alert = UIAlertController(
            title: "Время приготовления",
            message: "Выберите время приготовления",
            preferredStyle: .actionSheet
        )
        
        let times = [
            (10, "10 min"), (15, "15 min"), (20, "20 min"), (25, "25 min"), (30, "30 min"),
            (45, "45 min"), (60, "1 час"), (90, "1.5 часа"), (120, "2 часа"), (180, "3 часа")
        ]
        
        for (minutes, title) in times {
            alert.addAction(UIAlertAction(title: title, style: .default) { _ in
                self.presenter.didSelectTime(minutes, title: title)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }
    

    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
    
    private func addIngredient(name: String, quantity: String) {
        let row = IngredientRow(name: name, quantity: quantity) { [weak self] row in
            row.removeFromSuperview()
        }
        ingredientsStack.addArrangedSubview(row)
    }
    
    private func addNewIngredientRow() {
        let newRow = NewIngredientRow { [weak self] row, name, qty in
            guard !name.isEmpty, !qty.isEmpty else { return }
            self?.addIngredient(name: name, quantity: qty)
            self?.addNewIngredientRow()
            row.removeFromSuperview()
        }
        ingredientsStack.addArrangedSubview(newRow)
    }
    
    private func collectIngredients() -> [ExtendedIngredient] {
        var ingredients: [ExtendedIngredient] = []
        
        for view in ingredientsStack.arrangedSubviews {
            if let ingredientRow = view as? IngredientRow {
                let ingredient = ingredientRow.getIngredient()
                if !ingredient.name.isEmpty && !ingredient.quantity.isEmpty {
                    ingredients.append(ExtendedIngredient(
                        id: Int.random(in: 1...10000),
                        imageIngredient: "placeholder.png",
                        name: ingredient.name,
                        unit: ingredient.quantity,
                        amount: 1.0
                    ))
                }
            }
        }
        
        return ingredients
    }
}



extension CreateRecipeViewController: CreateRecipeViewProtocol {
    func showAlert(title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    func clearAllFields() {
        titleField.text = ""
        imageView.image = UIImage(resource: .media)
        servesRow.updateValue("03")
        timeRow.updateValue("20 min")
        instructionsTextView.text = "Write cooking instructions..."
        instructionsTextView.textColor = .placeholderText
        
        for view in ingredientsStack.arrangedSubviews {
            view.removeFromSuperview()
        }
        addNewIngredientRow()
        
        // Удален переход назад, так как экран открывается в табе
    }
    
    func updateServesValue(_ value: String) {
        servesRow.updateValue(value)
    }
    
    func updateTimeValue(_ value: String) {
        timeRow.updateValue(value)
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    func resetToDefaultImage() {
        imageView.image = UIImage(resource: .media)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension CreateRecipeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        
        if let image = selectedImage {
            presenter.didPickImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextViewDelegate

extension CreateRecipeViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Write cooking instructions..."
            textView.textColor = .placeholderText
        }
    }
}

// MARK: - Layout

private extension CreateRecipeViewController {
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        contentStack.addArrangedSubview(imageView)
        imageView.addSubview(changeImageButton)
        
        contentStack.addArrangedSubview(titleField)
        contentStack.addArrangedSubview(servesRow)
        contentStack.addArrangedSubview(timeRow)
        contentStack.addArrangedSubview(ingredientsTitle)
        contentStack.addArrangedSubview(ingredientsStack)
        contentStack.addArrangedSubview(instructionsTitle)
        contentStack.addArrangedSubview(instructionsTextView)
        contentStack.addArrangedSubview(createButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: Layout.contentInset),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: Layout.contentInset),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -Layout.contentInset),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -Layout.bottomInset),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -Layout.contentInset * 2),
            
            imageView.heightAnchor.constraint(equalToConstant: Layout.imageHeight),
            
            changeImageButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: Layout.changeButtonInset),
            changeImageButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -Layout.changeButtonInset),
            changeImageButton.widthAnchor.constraint(equalToConstant: Layout.changeButtonSize),
            changeImageButton.heightAnchor.constraint(equalToConstant: Layout.changeButtonSize),
            
            titleField.heightAnchor.constraint(equalToConstant: Layout.titleFieldHeight),
            instructionsTextView.heightAnchor.constraint(equalToConstant: Layout.instructionsHeight),
            createButton.heightAnchor.constraint(equalToConstant: Layout.createButtonHeight)
        ])
    }
}
