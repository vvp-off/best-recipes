//
//  CustomButton.swift
//  Best Recipes
//
//  Created by Иван Семенов on 15.08.2025.
//

import UIKit

final class CustomButton: UIButton {
    
    var customTitle: String? {
        didSet {
            setTitle(customTitle, for: .normal)
        }
    }
    
    init(customTitle: String) {
        super.init(frame: .zero)
        self.customTitle = customTitle
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        titleLabel?.font = .poppinsRegular(size: 16)
        layer.cornerRadius = 20
        backgroundColor = .primary
        setTitleColor(.white, for: .normal)
        setTitle(customTitle, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
