//
//  InfoRow.swift
//  Best Recipes
//
//  Created by Мария Родионова on 21.08.2025.
//


import UIKit

final class InfoRow: UIView {

    private enum Layout {
        static let height: CGFloat = 60
        static let iconSize: CGFloat = 36
        static let arrowSize: CGFloat = 16
        static let horizontalInset: CGFloat = 12
        static let spacing: CGFloat = 8
        static let cornerRadius: CGFloat = 12
    }

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()

    private let arrowView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .arrowRight))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray2
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private var tapAction: (() -> Void)?

    init(icon: UIImage, title: String, value: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
        layer.cornerRadius = Layout.cornerRadius
        heightAnchor.constraint(equalToConstant: Layout.height).isActive = true
        
        iconView.image = icon
        titleLabel.text = title
        valueLabel.text = value
        
        addSubviews()
        setupConstraints()
        setupGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func addTapGesture(action: @escaping () -> Void) {
        tapAction = action
    }

    func getValue() -> String {
        valueLabel.text ?? ""
    }

    func updateValue(_ newValue: String) {
        valueLabel.text = newValue
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTap() {
        tapAction?()
    }
}

// MARK: - Setup Constraints

private extension InfoRow {
    func addSubviews() {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(arrowView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.horizontalInset),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: Layout.iconSize),
            iconView.heightAnchor.constraint(equalToConstant: Layout.iconSize),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Layout.spacing),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.horizontalInset),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: Layout.arrowSize),
            arrowView.heightAnchor.constraint(equalToConstant: Layout.arrowSize),
            
            valueLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -Layout.spacing),
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -Layout.spacing)
        ])
    }
}
