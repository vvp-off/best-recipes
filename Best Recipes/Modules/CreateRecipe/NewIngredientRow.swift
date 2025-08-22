//
//  NewIngredientRow.swift
//  Best Recipes
//
//  Created by Мария Родионова on 21.08.2025.
//


import UIKit

final class NewIngredientRow: UIView {

    private enum Layout {
        static let height: CGFloat = 44
        static let qtyWidth: CGFloat = 100
        static let buttonSize: CGFloat = 28
        static let spacing: CGFloat = 8
    }

    private let nameField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Item name"
        textField.font = .systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let qtyField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Quantity"
        textField.font = .systemFont(ofSize: 15)
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        return textField
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .plusBorder), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let onAdd: (NewIngredientRow, String, String) -> Void

    init(
        onAdd: @escaping (NewIngredientRow, String, String) -> Void
    ) {
        self.onAdd = onAdd
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Layout.height).isActive = true
        
        addSubviews()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupActions() {
        addButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.onAdd(self, self.nameField.text ?? "", self.qtyField.text ?? "")
            self.nameField.text = ""
            self.qtyField.text = ""
        }, for: .touchUpInside)
    }
}

// MARK: - Setup Constraints

private extension NewIngredientRow {
    func addSubviews() {
        addSubview(nameField)
        addSubview(qtyField)
        addSubview(addButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                nameField.leadingAnchor.constraint(equalTo: leadingAnchor),
                nameField.centerYAnchor.constraint(equalTo: centerYAnchor),

                qtyField.leadingAnchor.constraint(equalTo: nameField.trailingAnchor, constant: Layout.spacing),
                qtyField.centerYAnchor.constraint(equalTo: centerYAnchor),
                qtyField.widthAnchor.constraint(equalToConstant: Layout.qtyWidth),

                addButton.leadingAnchor.constraint(equalTo: qtyField.trailingAnchor, constant: Layout.spacing),
                addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                addButton.widthAnchor.constraint(equalToConstant: Layout.buttonSize),
                addButton.heightAnchor.constraint(equalToConstant: Layout.buttonSize),

                nameField.trailingAnchor.constraint(lessThanOrEqualTo: qtyField.leadingAnchor, constant: -Layout.spacing)
            ])
    }
}
