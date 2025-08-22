//
//  IngredientRow.swift
//  Best Recipes
//
//  Created by Мария Родионова on 21.08.2025.
//


import UIKit

final class IngredientRow: UIView {

    private enum Layout {
        static let height: CGFloat = 44
        static let qtyWidth: CGFloat = 100
        static let buttonSize: CGFloat = 28
        static let spacing: CGFloat = 8
    }

    private let nameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let qtyField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()

    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .minusBorder), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let onRemove: (IngredientRow) -> Void

    init(name: String, quantity: String, onRemove: @escaping (IngredientRow) -> Void) {
        self.onRemove = onRemove
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Layout.height).isActive = true

        nameField.text = name
        qtyField.text = quantity

        addSubviews()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getIngredient() -> (name: String, quantity: String) {
        (nameField.text ?? "", qtyField.text ?? "")
    }
    
    private func setupActions() {
        removeButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.onRemove(self)
        }, for: .touchUpInside)
    }
}

// MARK: - Setup Constraints

private extension IngredientRow {
    func addSubviews() {
        addSubview(nameField)
        addSubview(qtyField)
        addSubview(removeButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
            nameField.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameField.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            qtyField.leadingAnchor.constraint(equalTo: nameField.trailingAnchor, constant: Layout.spacing),
            qtyField.centerYAnchor.constraint(equalTo: centerYAnchor),
            qtyField.widthAnchor.constraint(equalToConstant: Layout.qtyWidth),
            
            removeButton.leadingAnchor.constraint(equalTo: qtyField.trailingAnchor, constant: Layout.spacing),
            removeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            removeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            removeButton.widthAnchor.constraint(equalToConstant: Layout.buttonSize),
            removeButton.heightAnchor.constraint(equalToConstant: Layout.buttonSize),
            
            nameField.trailingAnchor.constraint(lessThanOrEqualTo: qtyField.leadingAnchor, constant: -Layout.spacing)
        ])
    }
}
